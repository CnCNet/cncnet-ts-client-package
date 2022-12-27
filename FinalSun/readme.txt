FinalSun 1.01
----------------------------


9.6.2001


Version 1.01
BUILT BY: MATTHIAS WAGNER

If you need a manual and tutorials, just press F1 after FinalSun has finished loading.


Copyright by Matthias Wagner 1999-2001

Thanks for reading this file. Please read the whole file AND the manual
First a note: FinalSun is definitly not finished yet! So, there may be (crashing?) bugs. If you find some,
please report them by mail or by posting them at the forum on finalsun.wagnerma.de
If you create or edit a map, save very often and early, as this is still a beta version.

DLLs: Download at http://finalsun.wagnerma.de/, complete list of all DLLs needed at the end of this file.

CREDITS
-------
Olaf van der Spek for his XCC code and mappack encoding/decoding code
Thalassicus for many good tutorials
Jonathan Wilson for his work on ts editing
Felix "the Chickmac" Kelm
thonliner from www.theonliner.de
Alex and Michael from ccin.de
DeeZire for many many triggers
Gustav Ladén for many many many high quality pictures
Omer Strulovich (Shiroko) for his editing guide
Igor K. (I don´t know complete name)
Matt Wolf
Steve Childs & his Editor SunEdit 2k
War Machine for overlay help
Maurice van Mil
Kidglove for some infos
NodScorpy from AGressivenodscorpions (website http://agressivenodscorpions.webhostme.com, email guestx@dolfijn.nl) for additional trigger info
Dany for standard maps
[UCD]Reaper for standard maps
Ben Lankamp for translating
Daniel from strategyzone.org for translating
TallCommando
Harry for Scripttypes
Bigchump for structure options
"User"
Jurrian de Valk for his mappack compression algorithms


CONTACT
-------
info@wagnerma.de to contact me
FinalSun website (english+german): finalsun.wagnerma.de
My personal website (english): www.wagnerma.de
SunEdit 2k: www.childs-play-software.co.uk/se2k
FinalAlert 2 and FinalAlert 2 YR: www.westwood.com


LICENSE
-------
You are not allowed to use this editor with a demo or illegal version of Tiberian Sun, buy the game and enjoy it :).
The program is freeware, so you get it "as it is", the author is not responsible for any damage caused by the program.
Electronic Arts and Westwood don´t provide ANY support for this editor.
The editor is NOT a official editor of Westwood or Electronic Arts.
You may not sell maps created with this editor without written permission of the author of this editor.
-------

YOU NEED
--------
FinalSun:
- Win9x or Win2k
- DirectX 6

FinalSun: 
- Tiberian Sun installed 
- RAM: 32MB physical should be the lower limit, and the harddisk your page/swap file is on should have
  more than 150 MB free. 

I recommend using DirectX 8.0. It speeds up FinalSun and TS.


KNOWN ISSUES/BUGS
-----------------
- If FinalSun crashes while loading pictures, switch into another color mode by right clicking on your desktop and selecting properties. Select the correct tab and switch to another color mode. Then try again.
  If it doesn´t work, try a lower resolution. And if even this doesn´t help, check the end of this file that has additional notes
- Although FinalSun should now save every map on every PC fine, please save your work as often and early as possible. 


HOW TO START
------------
After FinalSun has finished loading, press F1 to show the manual and
some tutorials.
If after the release of this version any bugs get known, they will be listed at finalsun.wagnerma.de, probably
with a workaround idea if existing. So you should visit FinalSun.wagnerma.de if there are problems before
mailing me.

PLEASE!!! Read the manual by pressing F1 in FinalSun.

CHANGES SINCE 1.00
------------------
-	fixed some bugs
-	faster overlay placing

CHANGES SINCE 0.98 Alpha 4
--------------------------
-	Added most FA2/FA2YR functionality
-	fixed bugs

CHANGES SINCE 0.98 Alpha 3 (2.2.2001)
-------------------------------------
-	MMX saving should always work now
-	Working compression, no uncompressed saving anymore needed
-	New minimap display, similar to RA2/TS
-	Right click scrolling
-	IsoView speed increased (=> faster interface)
-	Several bugfixes and smaller improvements

CHANGES SINCE 0.98 Alpha 2 (8.1.2001)
-------------------------------------
-	MMX Saving
-	AutoUpdate for future releases
-	Copy & Paste tools (even between FinalSun<->FinalAlert)
-	Graphics loading bug fixed
-	Use PageUp and PageDown keys to change height while placing tiles
-	Smaller improvements
-	Raise/lower terrain uses brush size

CHANGES SINCE 0.98 Alpha 1 (23.12.2000)
-------------------------------------
-	AutoShore and AutoLat may be disabled
-	Convert bitmap images into maps! (converts blue into water, for example)
-	AutoShore improved
-	AutoCliff improved
-	Faster tile placing
-	Lots of bugfixes
-	User friendly setup
-	Additional trigger flags (Thanks Watiz)
-	High wooden bridges and low concrete bridges support

CHANGES SINCE 0.97 Final (16.12.2000)
-------------------------------------
-	AutoShore now immeadiatly applied while painting water
-	AutoShore working for both FinalSun and FinalAlert now
-	Full tutorial for making a multiplayer map from scratch
-	2 other tutorials added (thanks Thalassicus)
-	Map compression should work more often now
-	General ground types now paintable using the object browser
-	Problems with hangups or crashes while loading graphics on some PCs should be fixed
-	Smaller improvements
-	Better flatten terrain tool
-	Bugfixes

CHANGES SINCE 0.97a6 (9.12.2000)
--------------------------------
-	Previews/thumbnails for multiplayer maps will be shown in Red Alert 2 / Tiberian Sun
-	FinalAlert only: AutoShore - create the shores for your whole map with just one click!
-	Dialog for saving options
-	Improved code for ramps engine and AutoLeveler
-	Smaller improvements
-	Bugfixes

CHANGES SINCE 0.97a5 (5.12.2000)
--------------------------------
-	AutoLeveler works better
-	First alpha of: Cliff painting tools! Just drag your cliffs as you need them!
-	Redo tool added (opposite of the Undo tool)
-	Ramps engine updated (for raise and lower ground tools etc.)
-	Smaller improvements & bugfixes
-	Tooltips (quickinfo) for all tools

CHANGES SINCE 0.97a4 (3.12.2000)
--------------------------------
-	fixed a crash bug occuring on some machines when voxels were loaded

CHANGES SINCE 0.97a3 (19.11.2000)
---------------------------------
-	Automatic LAT smoothing (for sand, rough grass, etc)!
-	Voxel support (images for units and aircraft)!
-	Easier new map assistant
-	Beginner mode interface -> easier navigation
-	First alpha of: AutoLeveler! (automatically "fills" cliffs, MapTools->AutoLevel!)
-	Minimap code completely new and faster
-	Much faster mapview

CHANGES SINCE 0.97a2 (10.11.2000)
---------------------------------
-	Compression for maps
-	Automatic map transfer for RA2 (in Internet and LAN games!)
-	Very good trigger and teamtype tuturials made by Thalassicus added
-	New RA2 specific triggers (thanks DeeZire for some)
-	Support for disabled triggers
-	FinalAlert: Teamtypes support Transport starting location
-	Map borders fixed, added visible area border
-	Several bugfixes

CHANGES SINCE 0.97a1 (5.11.2000)
--------------------------------
-	Fill areas with 1x1 tiles by pressing CTRL (useful for water maps)
-       LAN map problems should be fixed (hopefully)
-	Bugfixes
-	Other small improvements
-	FAQ and manual updated

CHANGES SINCE 0.96a2 (1.11.2000)
--------------------------------
-	Dynamic graphics loading (much less memory usage!)
-	Graphics loading bugs fixed
-	Fixed bugs
-	FinalAlert: Supporting RA2.csf (unit and building names automatically translated)
-	HTML manual: much more detailed and better organized (more details about placing cliffs, and a big FAQ)!
-	A few trigger issues for RA2 fixed (people who know FSData.ini should have a look into it!)
-	Manual reachable from inside FinalSun / FinalAlert: Press F1

CHANGES SINCE 0.96a1 (15.10.2000)
---------------------------------
-	Edit RA2 Maps with FinalAlert, TS maps with FinalSun!
-	Recruitable & Flying flags for Infantry
-	Better 3d cursor
-	FinalAlert: Automatic countries support

CHANGES SINCE 0.95a4 (18.09.2000)
---------------------------------
-	New trigger dialog, much more comfortable
-	Global variables
-	Unload cargo script parameter known
-	Trigger bugs fixed
-	Many bugs fixed
-	Weapons & Projectiles: SunEdit2k interface and mod map bugs fixed
-	Shift key works again when placing terrain
-	Using arrow keys to scroll through tiles and tilesets
-	Change map height tool (move whole map up and down)
-	Only allows to place buildings of correct theater
-	Building palettes all loaded correctly (correct colours)
-	Recruitable flag for Aircraft (for Create team trigger)
-	Homepage links

CHANGES SINCE 0.95a3 (08.09.2000)
---------------------------------
-	Support for multiple infantry on one field
-	Quite many bugfixes
-	Using much less memory (now only around 30 MB)
-	Save bug fixed (sometimes didn´t save!)
-	Check map bugs fixed
-	Almost full trigger support! (thanks DeeZire!)
-	Node bugs fixed
-	Manual updated
-	Much less memory usage

CHANGES SINCE 0.95a2 (01.09.2000)
---------------------------------
- 	Terrain editing bugs fixed
-	Display bugs fixed
-	Much faster isoview and terrain editing
-	Show/Hide Field/Tileset function (make for example cliffs invisible for easier editing)
-	Check map function extended (checks for missing triggers, tags, taskforces & scripttypes)
-	Dynamic loading of graphic, dynamic loading of mix data (saves more than 100 MB RAM, so FinalSun should work on almost any PC at least in 16 bit color mode!)
-	Faster loading
-	Overlay browser (like the terrain browser)
-	Overlay & Terrain browser in main window
-	Tag-Repeat bug fixed
-	Support for XCC Mixer fixed (was accidently not available in 0.95a2)
-	Upgrades-bug fixed (Upgrades for buildings now appear correctly in TS)
-	Bugfix for Mappack packing (if height of map was bigger than width, the top of the map was cut)
-	Several saving bugfixes
-	You can now again change screen resolution or run TS and FinalSun will not exit but reload all graphics
-	Tunnel (tubes) support
-	Manual updated (new user interface, 2 tutorials about win/lose triggers and tunnel editing)

CHANGES SINCE 0.94a (23.05.2000)
--------------------------------
-	Better user interface
-	TERRAIN EDITING, thanks to Olaf for mappack compression encoding/decoding
-	Place for example streets, water, cliffs
-	Create completely new maps
-	Automatically detects Tiberian Sun (no need to enter sun.exe anymore)
-	Overlay is displayed using Tiberian Sun´s graphics
-	Rules.ini settings are saved at top of map file
-	And many bug fixes (for example vehicles bug)

CHANGES SINCE 0.93b (20.04.2000)
--------------------------------
-	Faster loading
-	Support of making new (plain) maps without using existing maps
-	Better SHP support (now even for trees)
-	Better mod support
-	Showing terrain (yes, you have read correct ;)

CHANGES SINCE 0.93a (12.04.2000)
--------------------------------
-	Fixed 1 bug: Sometimes FinalSun crashed while loading

CHANGES SINCE 0.93 (07.04.2000)
-------------------------------
-	Fixed 2 Bugs: Color depth may be less than 24 bit and FinalSun doesn´t anymore crash after screen resolution has been reset (like when switching from Tiberian Sun to FinalSun)

CHANGES SINCE 0.92p
-------------------
-	Even more bugfixes
-	Firestorm support
-	SHP file support for IsoView
-	Direct support for mods
-	Reading the MIX files of Tiberian Sun
-	Trigger error fixes
-	Compatible with Tiberian Sun 2.02/Firestorm, maps should work fine again
-	Win/Lose triggers bugfixed
-	Manual Finalsun.doc updated

Thanks to Olaf van der Spek. Without his XCC code, many things would have been impossible.

CHANGES SINCE 0.91 (01.14.2000)
-------------------------------
-	Quite many bugfixes
-	Standard maps for immediate creation of new missions
-	Dutch & Swedish language support
-	Minimap
-	Bugs of new map assistant fixed
-	Extended multilanguage support
-	A "simple" option: Only the most important features of FinalSun are enabled, for beginners
-	3 new trigger actions (from NodScorpy)

CHANGES SINCE 0.9 (11.12.1999)
------------------------------
-	Multi-language support for many parts
-	Tags for team-types
-	Tips
-	New map assistant improved
-	Some describing text errors fixed
-	Some bugs fixed (you can now again use alt-tab)
-	Better houses support
-	Nodes should work fine
-	AITriggerTypes better known
-	Support for movies and other stuff
-	Iso-view speed again increased


CHANGES SINCE 0.86 (11.28.1999)
-------------------------------
-	Big perfomance improvement
-	Support of EVERY overlay type
-	Many bugfixes
-	Internal code improvement
-	AITriggerTypes can be created
-	Scripttypes features enhanced (thanks to Maurice van Mil)


CHANGES SINCE 0.85 (11.23.1999)
-------------------------------
-	MANY HIGH QUALITY PICTURES (Thanks to Gustav Ladén)
-	DIRECTX 6.0 SUPPORT
-	Improved performance
-	Placing tracks
-	Placing bridges
-	Fast change of unit/building owner (no need to use the properties anymore)
-	Statusbar now shows information about units/buildings
-	AITriggerTypes can now be enabled
-	Many bugfixes


CHANGES SINCE 0.82 (11.14.1999)
-----------------------------
-	OVERLAY SUPPORT
-	NEW ISO-VIEW USER INTERFACE
-	Bugfixes


CHANGES SINCE 0.8 (11.6.1999)
-----------------------------
-	ScriptTypes support
-	Extended Trigger support
-	SUNEDIT 2K SUPPORT (IF YOU HAVE AT LEAST BETA 4, PREVIEW 1)
-	Bugfixes
-	Updated manual


CHANGES SINCE 0.75 (11.4.1999)
------------------------------
-	Trigger support
-	Tag support
-	Bugfixes
-	Manual


CHANGES SINCE 0.7 (11.2.1999)
-------------------------------
-	Celltag support
-	Drag & Drop for celltags & waypoints
-	Bugfixes, one very important: infantry & aircraft wasn´t shown on map, don´t know how I didn´t recognize that infantry wasn´t shown.. :)! now fixed.
-	Team types support (puh much work :)
-	Task forces support


CHANGES SINCE 0.62 (10.24.1999)
-------------------------------
-	Base nodes (means you can tell the ai to rebuild buildings if they are destroyed)
-	Building upgrades (though not visible in the iso-view of the editor yet, but they are in the game!)
-	Other building properties included.
-	Using DirectDraw(c)
-	Many bugfixes
-	Other stuff

CHANGES SINCE 0.6 (10.24.1999)
------------------------------
-	Deleting waypoint option was available anytime. If no waypoint was present, editor crashed. FIXED
-	Many city-buildings graphics added
-	small non-critical bugs fixed
-	sample map added

CHANGES SINCE 0.5 (10.23.1999)
------------------------------
-	Waypoints supported
-	some new graphics
-	Drag & Drop (see FAQ!!! COOL FEATURE)
-	fixed some small bugs

CHANGES SINCE 0.4 (10.22.1999)
------------------------------
-	Iso View speeded up and improved
-	Aircraft support
-	Additional iso-graphics for units/infantry
-	Houses


FAQ
---
Q:	How can I create a zoom trigger?
A: 	DeeZire answered this in an email he sent to me:
	If you wanted to zoom on a particular place, you must first use the 'move camera and scroll to waypoint' action (#48) and then zoom in. 
	The zoom rate is controlled by an undocumented keyword which must be placed in the [General] section of RULES.INI or your map file:
	ZoomInFactor=N    } I dont know how N is measured but a value of 4 works OK.
	Matze´s addition: It works to use Edit->Ini to create a [General] section inside the map file and insert the key.

Q: 	How can I create a really new map?
A: 	As FinalSun now offers support for creating new maps, there are now 2 ways to create new maps. Either
	you use File->New or you can create a multiplayer map in the random map editor in TiberianSun (before version 1.15 only!). 
	To do this, just create a random map and quit Tiberian Sun again. Now you can
	load the file "RandomMap.Map" into FinalSun and edit it.

Q:	Can I create new unit types?
A:	Now directly supported by SunEdit 2k. Download the newest release to get extended support.

Q:	Can I play the maps online? And use the new unit types online?
A:	Yep, but the synchronisation limit is at 40 seconds, thats enough for around 500-550kb (so 130-150 kb for the map
	for 4 players online). If this limit is broken, ... bad... :). You can use the unit types online.

Q:	How can I keep the map file small, so that I´m able to play with 4 players online?
A:	Of course you can choose a small map size in the random map generator. Another possibility is to "hide" the preview.
	Just say "Yes" when the program asks you to do that when you save the map. Unfortunately the maps FinalSun produces are
	kinda big in this alpha, as mappack encoding doesn´t use compression yet.

Q:	I already have maps / I´m using a Rules.INI. Can I import my settings in this files?
A:	Yes you can. At the "All" Section, click on "Import another INI File". You can now choose what to import, whether
	only specified sections or the whole file (please DON´T import the whole file if it´s too big, for example the
	rules.ini!). INI files are: *.mpr, *.map, *.ini.

Q:	Ok i´ve made a multiplayer map. How can I play it?
A:	In Tiberian Sun in the map settings dialog, choose "multiplayer maps" and click on your one (mostly at the end of
	the list!). Note that you cannot load the map in the random map editor.

Q:	I´ve created a single player mission by changing an existing one. How can I play it?
A:	You can name the file like the one that you changed (gdi1a.map, nod1a.map for orig TS, fsgdi01.map or fsnod01.map for Firestorm).
	A better solution: Copy FSBattle.ini from the FS to the TS directory and name it Battle.ini. Open the file with
	notepad and change the settings there, best way is to create a new campaign. Then you can choose your campaign
	in TiberianSun.

Q:	What is that new houses page?
A:	The main reason I have included this feature is for singleplayer maps. A house is a "player", for example
	the GDI, or the civilists. Note that this is not a side like GDI/NOD, it´s specific to the map.
	I have not yet tried out much with houses in Multiplayer yet, but I found out that only the standard
	houses "GDI", "Nod", "Neutral" & "Special" are supported, else the game could crash! An idea to implement
	a multiplayer map with a predefined enemy (with buildings etc!) would be to use Neutral or Special as
	AI-house (but i haven´t tried out yet!).
	Always use "Prepare houses" before doing anything else in SP and MP if no houses are yet placed.
	 (it´s simple and it helps to don´t make a mistake. 	Experienced users may not need to do this!).

Q:	What is that new drag & drop feature? (= how can I copy units/buildings or move them?)
A:	Instead of deleting a building and placing it somewhere else, you can now simply click with the left
	mouse button on the building and move your mouse with holded down mouse button. You can now see a line that
	shows where the building/unit will be placed at. If you stop holding down the button, the unit/building
	will be moved there. If you hold down additionally shift, it will be "copied" there, that means you can 
	create for example a big army without having to create every unit yourself.
	Note: if you move/copy a building and it is to big to be placed at the new position, no warning appears!
	That means you can probably get problems if you don´t make sure that there is enough space!


FEATURE					BUILT-IN
Basic					Yes
Special Flags				Yes
Lighting				Yes
General editor for sections		Yes
Inserting of other INI files		Yes
Version of rules.ini included in EXE	Not anymore included. Uses directly Tiberian Sun´s rules.ini 
Graphical editor			Iso-view included (terrain is shown and EDITABLE!)
Inserting Trees				Yes
Inserting Units				Yes
Inserting Buildings			Yes
Inserting Infantry			Yes
Inserting Aircraft			Yes
Inserting waypoints			Yes
Inserting base nodes			Yes
Object settings				Yes
General map settings			Yes
Triggers etc				Yes
Scripts					Yes
AITriggerTypes etc			Yes
Minimap					Yes
Placing cliffs, water, roads, etc.	Yes


Note: it may be that I have not listed every feature missing/built in.


***********
DLLS NEEDED
***********

I think this should be all DLLs:
ADVAPI32.DLL
COMCTL32.DLL 
DDRAW.DLL 
FSUNLIB.DLL 
GDI32.DLL 
KERNEL32.DLL
MFC42.DLL   
MSVCP60.DLL 
MSVCRT.DLL  
NTDLL.DLL   
SHELL32.DLL  
SHLWAPI.DLL  
USER32.DLL  
VERSION.DLL

Now DLLs, that are loaded delayed:
COMDLG32.DLL
CRYPT32.DLL 
MPR.DLL    
MSOSS.DLL  
MSVCRT20.DLL 
ODBC32.DLL  
OLE32.DLL  
OLEAUT32.DLL 
OLEDLG.DLL  
OLEPRO32.DLL
RPCRT4.DLL
URLMON.DLL  
WININET.DLL  
WINSPOOL.DRV 
WSOCK32.DLL  


*****************************************************
WORKAROUND IF FINALSUN CRASHES WHILE LOADING PICTURES
*****************************************************
First you should try switching to 16 bit color depth and probably a lower resolution.
If this doesn´t work, you should make sure that c:\ (or where you have your swap file) has enough free space (300-400 MB are perfect).
If this also doesn´t help, you can try to increase your swap file size manually (but please only do this if you are experienced!).




Microsoft, DirectX, and DirectDraw are registered trademarks or trademarks of Microsoft
Corporation in the USA and/or other countries.

Electronic Arts, Westwood Studios, C&C 2 Tiberian Sun and C&C Red Alert 2 are trademarks
or registered trademarks of Electronic Arts in the United States, Germany and/or
in other countries. All rights reserved.

SunEdit 2k is copyrighted by Childs-Play-Software.