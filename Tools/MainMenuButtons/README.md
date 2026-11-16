# Main menu buttons

`make_buttons.py` generates the text buttons of the Default Theme main menu and Extras window
(`campaign.png`, `campaign_c.png`, ...) so they match the vanilla Tiberian Sun menu: same typeface,
size, glow, drop shadow and outline.

Output locations:

| Language | Folder |
|---|---|
| en | `Resources/Default Theme/MainMenu/` |
| others | `Resources/Translations/<lang>/Default Theme/MainMenu/` |

The Legacy Theme uses different art and isn't generated here.

## Running it

Requirements: Python 3 with `numpy`, `scipy` and `pillow`, and the URW Gothic fonts from
[URW base35](https://github.com/ArtifexSoftware/urw-base35-fonts). `--fonts` is the folder holding
`URWGothic-Demi.ttf` and `URWGothic-Book.ttf` (the repo's `fonts/` folder). The fonts aren't stored
in this repo.

```
python make_buttons.py --fonts path/to/urw-base35-fonts/fonts
python make_buttons.py --fonts path/to/urw-base35-fonts/fonts --lang ru --only quickmatch
python make_buttons.py --fonts path/to/urw-base35-fonts/fonts --out preview
```

Without `--out` it overwrites the PNGs in `Resources/`. Running it on an unchanged `buttons.json`
reproduces the committed files byte for byte.

## Adding a button or a language

All per-button data is in `buttons.json`:

```json
"de": {
  "exitgame": {"label": "Beenden", "size": [167, 72], "center_x": 82.5}
}
```

- `label`: the text. URW Gothic Demi covers Latin (including German umlauts and ß), Cyrillic and Greek.
- `size`: the image size. Use height 72 for the big menu buttons (300 wide) and height 50 for the small
  ones (Credits, Statistics, Map Editor). The height picks the text style (size, weight, spacing); see
  `TEXT_STYLE` in the script.
- `center_x`: where the centre of the text goes. For a new button use half the width. The existing
  values with .5 or odd offsets come from the older TSC art and keep the text where it was.

If the script warns that the glow is cut off at an edge, make the image wider instead of shrinking the
text. The client places buttons by their top-left corner (`Location=` in `MainMenu.ini` /
`ExtrasWindow.ini`) and takes the size from the texture. So extra width on the right needs no other
change. Extra width on the left needs the button's `Location` moved left by the same amount, in every
language, because all languages share one `Location`. That's why, in all languages, `exitgame` has
8px and `mapeditor` 12px of extra width on the left compared to the old TSC art. Their `Location` in
the base INIs moved left to match: `btnExit` 145 → 137, `btnMapEditor` 715 → 703 (`MainMenu.ini`),
`btnExMapEditor` 490 → 478 (`ExtrasWindow.ini`). The Legacy Theme INIs pin the old positions because
Legacy inherits the base INIs (`BasedOn=`) but its art isn't padded.

A per-language `Location` is possible in `Translations/<lang>/Translation.ini`
(`INI:Controls:MainMenu:btnExit:Location=x,y`), but the client only applies translated attributes
that the control's INI section already sets. `X=` is ignored when the section uses `Location=`.

## How the look was derived

The reference is the vanilla menu art in `GMENU.MIX` (`TB01NC.PCX` and so on, 640x400 menu), with
`TSTBACK.PCX` as the same background without buttons. Subtracting the background from a button image
isolates the text effect.

**Typeface.** Vanilla uses ITC Avant Garde Gothic Demi. URW Gothic Demi is a metric clone. A
least-squares fit of six vanilla word widths gives 15.35px font size and 0.29px tracking at 640x400,
and matches every word to within 1px. The old TSC art used Century Gothic instead, which is lighter and
has different letterforms.

**Small row.** Vanilla has no small buttons, so Credits, Statistics and Map Editor use a lighter
style to read as secondary: URW Gothic Book with 0.375px faux bold (strokes thickened on every side,
stems ~2.35px vs Demi's 2.9px) and 0.75px extra letter spacing, so the faux bold doesn't close up the
gaps. Faux bold needs finer steps than 1/4 px, so these render at 8x supersampling instead of 4x.
Because the dark glow depends on how much ink is nearby, the lighter strokes also give a slightly
lighter dark glow, e.g. inside the "C" of Credits. To make the black match the big buttons exactly,
the effect layers would have to be drawn from a Demi-weight copy of the text.

**Scale.** The client's `mainmenubg.png` is `TSTBACK.PCX` scaled 1.8x (1152x720, centred in 1280x720
with 64px margins), not 2x. The menu row spacing confirms it: vanilla 30px x 1.8 = 54px. So the text is
vanilla x 1.8: a 27.6px font with a 20.4px cap height on the 72px-tall buttons.

**Effect.** Fitted per pixel against the vanilla buttons. The dark glow was then tuned to match how much
of the area near the letters is near-black. A plain least-squares fit makes it too weak, because the
glyphs never line up with the PCXs exactly. The hard-edged outline was added by eye.

## Effect recipe (for re-creating it elsewhere, e.g. in-game)

Distances are in vanilla 640x400 pixels at a 15.35px font. Multiply them by `font size / 15.35` for
other sizes (x1.8 for the client). `glyph` is the text coverage mask (0..1). `gauss(m, s)` is a
Gaussian blur with sigma `s`. `d` is the distance from the glyph edge, outside the glyph.

Layers, bottom to top:

| # | Layer | Alpha | Colour (idle / hover) |
|---|---|---|---|
| 1 | glow | `1 - exp(-k1 * gauss(glyph, s1))`, idle k1=18.25 s1=4.25, hover k1=17.46 s1=4.36 | `#0F4D56` / `#585959` |
| 2 | dark glow | `clamp(6.0 * gauss(glyph, 4.5) - 0.6, 0, 1)` | black |
| 3 | drop shadow | `gauss(glyph shifted by (+2, +2), 0.4)` | black |
| 4 | outline | `smoothstep(t)` with `t = clamp((1.3 - d) / 1.0, 0, 1)`: solid to 0.3px, fades out by 1.3px | black |
| 5 | text | `glyph` | `#2DE4FF` / `#FFFFFF` |

Layer 1 sits over the background. Each later layer is composited normally ("over") on top. The dark
glow's hard clamp makes it solid black near the letters and in enclosed spaces (inside "C", "a", "o",
between letters), then fall off within ~6px. That matches vanilla, where the dark glow and the drop
shadow merge into pure black.

For a cheaper real-time version:
- layers 2 and 3 can be pre-rendered once per string;
- layer 1 is an ordinary outer glow;
- layer 4 is a 1px soft stroke at 640x400 (about 2px at the client's 1.8x scale).

The glow reaches about 13px from the letters at 640x400, so leave that much margin around the text.
