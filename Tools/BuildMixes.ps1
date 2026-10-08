#Requires -Version 5.1
[CmdletBinding()]
param(
    [string]$SourceRoot,
    [string]$OutputRoot
)

$ErrorActionPreference = 'Stop'

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

if (-not $SourceRoot)
{
    $SourceRoot = Join-Path $scriptRoot '..\MixSource'
}

if (-not $OutputRoot)
{
    $OutputRoot = Join-Path $scriptRoot '..\MIX'
}

# Compile the filename hash in memory using Windows' built-in .NET support.
if (-not ('TscMixId' -as [type]))
{
    Add-Type -TypeDefinition @"
using System;
using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;

public static class TscMixId
{
    public static int ForName(string name)
    {
        foreach (char character in name)
        {
            if (character > 127)
                throw new ArgumentException("MIX filenames must use ASCII: " + name);
        }

        if (name.StartsWith("_id_", StringComparison.OrdinalIgnoreCase))
        {
            var match = Regex.Match(name, @"^_id_([0-9a-fA-F]{8})(?:\.[^\\/]+)?$");

            if (!match.Success)
                throw new ArgumentException("Invalid encoded MIX ID: " + name);

            return unchecked((int)uint.Parse(match.Groups[1].Value, NumberStyles.HexNumber));
        }

        var original = Encoding.ASCII.GetBytes(name.ToUpperInvariant());
        var padded = new byte[(original.Length + 3) & ~3];
        Array.Copy(original, padded, original.Length);
        int remainder = original.Length & 3;

        if (remainder != 0)
        {
            padded[original.Length] = (byte)remainder;

            for (int index = original.Length + 1; index < padded.Length; index++)
                padded[index] = original[original.Length - remainder];
        }

        uint crc = 0xffffffff;

        foreach (byte value in padded)
        {
            crc ^= value;

            for (int bit = 0; bit < 8; bit++)
                crc = (crc >> 1) ^ ((crc & 1) == 0 ? 0 : 0xedb88320u);
        }

        return unchecked((int)(crc ^ 0xffffffff));
    }
}
"@
}

function Get-ContentHash([string]$Path)
{
    $stream = [IO.File]::OpenRead($Path)
    $hasher = [Security.Cryptography.SHA256]::Create()

    try
    {
        return [BitConverter]::ToString($hasher.ComputeHash($stream)).Replace('-', '')
    }
    finally
    {
        $hasher.Dispose()
        $stream.Dispose()
    }
}

function Assert-RegularPath([string]$Path)
{
    if (([IO.File]::GetAttributes($Path) -band [IO.FileAttributes]::ReparsePoint) -ne 0)
    {
        throw "Links and junctions are not supported: $Path"
    }
}

function Get-ArchiveFolders([string]$Path)
{
    Assert-RegularPath $Path

    foreach ($entry in Get-ChildItem -LiteralPath $Path -Force | Sort-Object Name)
    {
        Assert-RegularPath $entry.FullName

        if (-not $entry.PSIsContainer -or
            -not $entry.Name.EndsWith('.mix', [StringComparison]::OrdinalIgnoreCase))
        {
            throw "Expected a .mix source folder: $($entry.FullName)"
        }

        $entry.FullName
    }
}

function New-XccDatabase([string[]]$Names)
{
    # XCC local database: 32-byte signature, size/type/version, game/count, then names.
    [Array]::Sort($Names, [StringComparer]::Ordinal)
    $size = 52L

    foreach ($name in $Names)
    {
        $size += [Text.Encoding]::ASCII.GetByteCount($name) + 1
    }

    if ($size -gt [int32]::MaxValue)
    {
        throw 'The XCC filename database exceeds the format size limit.'
    }

    $stream = New-Object IO.MemoryStream
    $writer = New-Object IO.BinaryWriter($stream)

    try
    {
        $writer.Write([Text.Encoding]::ASCII.GetBytes('XCC by Olaf van der Spek'))
        $writer.Write([byte[]]@(0x1a, 0x04, 0x17, 0x27, 0x10, 0x19, 0x80, 0x00))
        $writer.Write([int32]$size)
        $writer.Write([int32]0) # Local database type
        $writer.Write([int32]0) # Format version
        $writer.Write([int32]2) # XCC game_ts
        $writer.Write([int32]$Names.Count)

        foreach ($name in $Names)
        {
            $writer.Write([Text.Encoding]::ASCII.GetBytes($name))
            $writer.Write([byte]0)
        }

        $writer.Flush()

        return ,$stream.ToArray()
    }
    finally
    {
        $writer.Dispose()
        $stream.Dispose()
    }
}

function New-MixArchive([string]$Directory)
{
    $members = @()
    $ids = @{}
    $totalSize = 0L
    $databaseName = 'local mix database.dat'
    $databaseId = [TscMixId]::ForName($databaseName)
    $databaseNames = New-Object 'Collections.Generic.List[string]'
    $databaseNames.Add($databaseName)

    foreach ($entry in Get-ChildItem -LiteralPath $Directory -Force | Sort-Object Name)
    {
        Assert-RegularPath $entry.FullName

        # The database is generated; .gitkeep only preserves empty source folders.
        if (-not $entry.PSIsContainer -and
            ($entry.Name -eq $databaseName -or $entry.Name -eq '.gitkeep'))
        {
            continue
        }

        $id = [TscMixId]::ForName($entry.Name)

        if ($id -eq $databaseId)
        {
            throw "Source member '$($entry.Name)' uses the reserved XCC database ID."
        }

        if ($ids.ContainsKey($id))
        {
            throw "MIX ID collision in '$Directory': '$($ids[$id])' and '$($entry.Name)'"
        }

        $ids[$id] = $entry.Name

        if ($entry.PSIsContainer)
        {
            if (-not $entry.Name.EndsWith('.mix', [StringComparison]::OrdinalIgnoreCase))
            {
                throw "Only nested .mix folders are allowed inside an archive: $($entry.FullName)"
            }

            [byte[]]$data = New-MixArchive $entry.FullName
        }
        else
        {
            [byte[]]$data = [IO.File]::ReadAllBytes($entry.FullName)
        }

        $members += [pscustomobject]@{ Id = $id; Data = $data }
        $totalSize += $data.LongLength

        # ID-only placeholders have no recoverable filename for XCC to hash.
        if (-not $entry.Name.StartsWith('_id_', [StringComparison]::OrdinalIgnoreCase))
        {
            $databaseNames.Add($entry.Name.ToLowerInvariant())
        }
    }

    [byte[]]$database = New-XccDatabase $databaseNames.ToArray()
    $members += [pscustomobject]@{ Id = $databaseId; Data = $database }
    $totalSize += $database.LongLength

    if ($members.Count -gt [int16]::MaxValue -or $totalSize -gt [int32]::MaxValue)
    {
        throw "Archive exceeds the Tiberian Sun MIX format limits: $Directory"
    }

    # The game binary-searches the index as signed 32-bit IDs.
    $members = @($members | Sort-Object Id)
    $stream = New-Object IO.MemoryStream
    $writer = New-Object IO.BinaryWriter($stream)

    try
    {
        # Extended, unencrypted MIX header, followed by count and payload size.
        $writer.Write([int32]0)
        $writer.Write([int16]$members.Count)
        $writer.Write([int32]$totalSize)
        $offset = 0

        foreach ($member in $members)
        {
            $writer.Write([int32]$member.Id)
            $writer.Write([int32]$offset)
            $writer.Write([int32]$member.Data.Length)
            $offset += $member.Data.Length
        }

        foreach ($member in $members)
        {
            $writer.Write([byte[]]$member.Data)
        }

        $writer.Flush()

        return ,$stream.ToArray()
    }
    finally
    {
        $writer.Dispose()
        $stream.Dispose()
    }
}

$stage = $null

try
{
    $SourceRoot = [IO.Path]::GetFullPath($SourceRoot).TrimEnd('\', '/')
    $OutputRoot = [IO.Path]::GetFullPath($OutputRoot).TrimEnd('\', '/')

    if (-not (Test-Path -LiteralPath $SourceRoot -PathType Container))
    {
        throw "MIX source directory is missing: $SourceRoot"
    }

    if ($OutputRoot.Equals($SourceRoot, [StringComparison]::OrdinalIgnoreCase) -or
        $OutputRoot.StartsWith($SourceRoot + '\', [StringComparison]::OrdinalIgnoreCase))
    {
        throw 'The output directory must be outside the MIX source directory.'
    }

    $archives = @(Get-ArchiveFolders $SourceRoot)

    if ($archives.Count -eq 0)
    {
        throw "No .mix source folders found in $SourceRoot"
    }

    [void][IO.Directory]::CreateDirectory($OutputRoot)
    Assert-RegularPath $OutputRoot
    $stage = Join-Path $OutputRoot ('.mix-build-' + [Guid]::NewGuid().ToString('N'))
    [void][IO.Directory]::CreateDirectory($stage)
    $pending = @()

    # Build every archive before replacing any installed output.
    foreach ($archive in $archives)
    {
        $relative = $archive.Substring($SourceRoot.Length + 1)
        $temporary = Join-Path $stage $relative
        $destination = Join-Path $OutputRoot $relative
        $parent = $destination

        while ($parent -and $parent.StartsWith($OutputRoot + '\', [StringComparison]::OrdinalIgnoreCase))
        {
            if (Test-Path -LiteralPath $parent)
            {
                Assert-RegularPath $parent
            }

            $parent = [IO.Path]::GetDirectoryName($parent)
        }

        [void][IO.Directory]::CreateDirectory([IO.Path]::GetDirectoryName($temporary))
        [IO.File]::WriteAllBytes($temporary, (New-MixArchive $archive))
        $pending += [pscustomobject]@{ Relative = $relative; Temporary = $temporary; Destination = $destination }
    }

    foreach ($item in $pending)
    {
        if (Test-Path -LiteralPath $item.Destination -PathType Leaf)
        {
            if ((Get-ContentHash $item.Temporary) -eq
                (Get-ContentHash $item.Destination))
            {
                Write-Host "Current $($item.Relative)"

                continue
            }

            [IO.File]::Replace($item.Temporary, $item.Destination, $item.Temporary + '.previous')
        }
        else
        {
            [void][IO.Directory]::CreateDirectory([IO.Path]::GetDirectoryName($item.Destination))
            [IO.File]::Move($item.Temporary, $item.Destination)
        }

        Write-Host "Built   $($item.Relative)"
    }

    Write-Host "$($archives.Count) MIX files ready."
}
catch
{
    [Console]::Error.WriteLine("MIX build failed: " + $_.Exception.Message)
    exit 1
}
finally
{
    if ($stage -and (Test-Path -LiteralPath $stage))
    {
        $resolvedStage = [IO.Path]::GetFullPath($stage)

        if (-not $resolvedStage.StartsWith($OutputRoot + '\.mix-build-', [StringComparison]::OrdinalIgnoreCase))
        {
            throw "Unexpected temporary directory: $resolvedStage"
        }

        Remove-Item -LiteralPath $resolvedStage -Recurse -Force
    }
}
