"""Generate the Default Theme main menu text buttons (idle + _c hover) in the vanilla Tiberian Sun style.

See README.md in this folder for how the look was derived and how to add buttons or languages.

usage:
  python make_buttons.py --fonts path/to/urw-base35-fonts/fonts               # all languages, into Resources/
  python make_buttons.py --fonts ... --lang de --only exitgame mapeditor
  python make_buttons.py --fonts ... --out preview                            # write to preview/<lang>/ instead

--fonts is a folder containing URWGothic-Demi.ttf and URWGothic-Book.ttf.
requires: Python 3, numpy, scipy, pillow
"""
import argparse
import json
import os

import numpy as np
from PIL import Image, ImageDraw, ImageFont
from scipy.ndimage import distance_transform_edt, gaussian_filter, shift as nshift

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.normpath(os.path.join(HERE, "..", ".."))
OUTPUT_DIRS = {"en": os.path.join("Resources", "Default Theme", "MainMenu")}  # others: Translations/<lang>/...

# --- Font and size -------------------------------------------------------------------------------
# Vanilla TS (GMENU.MIX TB*.PCX, 640x400) uses ITC Avant Garde Gothic Demi at ~15.35px with 0.29px
# tracking. URW Gothic is a metric clone. The client shows the vanilla menu background scaled 1.8x
# (1152x720 centred in 1280x720), so the text is scaled 1.8x as well.
VAN_SIZE = 15.35           # px at 640x400
TRACK = 0.29 / VAN_SIZE    # em
CAP_EM = 0.739             # URW Gothic cap height / em (same for Book and Demi)

# Text style per image height:
#   cap, top, scale  placement in the same terms the original TSC (Century Gothic) art used:
#                    reference cap height, cap top, scale. 21 * 0.9725 = 20.42px = vanilla cap 11.34px * 1.8.
#   font             URW Gothic weight file
#   embolden         faux bold: px added around every stroke (final-image px)
#   extra_track      px added between letters, 2 x embolden keeps the gaps of the unemboldened font
#   ss               supersampling factor; embolden must be a multiple of 1/ss
# The big 72px menu buttons are vanilla's own weight (Demi). The small 50px row (Credits, Statistics,
# Map Editor) has no vanilla counterpart and uses a lighter Book + faux bold so it reads as secondary.
TEXT_STYLE = {
    72: dict(cap=21, top=23, scale=0.9725, font="URWGothic-Demi.ttf", embolden=0.0, extra_track=0.0, ss=4),
    50: dict(cap=16, top=15, scale=1.0, font="URWGothic-Book.ttf", embolden=0.375, extra_track=0.75, ss=8),
}

# --- Effect --------------------------------------------------------------------------------------
# Fitted against the vanilla PCX buttons composited over the bare TSTBACK.PCX background.
# All distances are vanilla 640x400 pixels and get scaled by (font size / VAN_SIZE).
# Layers, bottom to top:
#   1. glow       alpha = 1 - exp(-k1 * gauss(glyph, s1))       coloured
#   2. dark glow  alpha = clip(k2 * gauss(glyph, s2) - c2, 0, 1) black, solid core + fast falloff
#   3. shadow     glyph offset (+off, +off), blurred by s3        black
#   4. outline    solid to OUTLINE px off the glyph edge, smoothstep fade over OUTLINE_SOFT px, black
#   5. glyph      fill colour
DARK = dict(k2=6.0, s2=4.5, c2=0.6, off=2.0, s3=0.4)
OUTLINE, OUTLINE_SOFT = 0.3, 1.0
STYLE = {
    "":   dict(fill=(45, 228, 255),  glow=(15, 77, 86), k1=18.25, s1=4.25, **DARK),  # idle
    "_c": dict(fill=(255, 255, 255), glow=(88, 89, 89), k1=17.46, s1=4.36, **DARK),  # hover
}


def render_glyphs(label, font, size, w, h, cx, top, ts):
    """Supersampled coverage of the label, ink centred on cx, cap top at `top`."""
    ss = ts["ss"]
    big = Image.new("L", (w * ss, h * ss), 0)
    d = ImageDraw.Draw(big)
    tr = TRACK * size * ss
    if ts["extra_track"]:
        tr += ts["extra_track"] * ss
    emb = int(round(ts["embolden"] * ss))
    xs = [font.getlength(label[:i]) + i * tr for i in range(len(label))]
    l0 = font.getbbox(label[0])[0]
    r1 = xs[-1] + font.getbbox(label[-1])[2]
    x0 = cx * ss - (l0 + r1) / 2
    y0 = top * ss - font.getbbox("H")[1]
    for x, ch in zip(xs, label):
        if emb:
            d.text((x0 + x, y0), ch, font=font, fill=255, stroke_width=emb, stroke_fill=255)
        else:
            d.text((x0 + x, y0), ch, font=font, fill=255)
    return np.asarray(big, float) / 255


def down(a, h, w, ss):
    return a.reshape(h, ss, w, ss).mean((1, 3))


def compose(hi, w, h, st, k, ss):
    """k = font size / vanilla font size."""
    glow = down(1 - np.exp(-st["k1"] * gaussian_filter(hi, st["s1"] * k * ss)), h, w, ss)
    dark = down(np.clip(st["k2"] * gaussian_filter(hi, st["s2"] * k * ss) - st["c2"], 0, 1), h, w, ss)
    o = st["off"] * k * ss
    shadow = down(gaussian_filter(nshift(hi, (o, o), order=1), st["s3"] * k * ss), h, w, ss)
    dist = distance_transform_edt(hi < 0.5) / ss / k
    t = np.clip((OUTLINE + OUTLINE_SOFT - dist) / OUTLINE_SOFT, 0, 1)
    outline = down(t * t * (3 - 2 * t) * (hi < 0.5), h, w, ss)
    cov = down(hi, h, w, ss)

    C = np.array(st["glow"], float) * glow[..., None]  # premultiplied colour
    A = glow
    for layer in (dark, shadow, outline):  # black layers
        C = C * (1 - layer[..., None])
        A = layer + A * (1 - layer)
    C = np.array(st["fill"], float) * cov[..., None] + C * (1 - cov[..., None])
    A = cov + A * (1 - cov)
    rgb = np.where(A[..., None] > 1e-4, C / np.maximum(A, 1e-4)[..., None], 0)
    return Image.fromarray(np.dstack([rgb, A * 255]).clip(0, 255).round().astype(np.uint8), "RGBA")


def make_button(spec, fonts_dir):
    w, h = spec["size"]
    ts = TEXT_STYLE[h]
    ss = ts["ss"]
    tcap = ts["cap"] * ts["scale"]
    top = ts["top"] + ts["cap"] / 2 - tcap / 2
    size = tcap / CAP_EM
    font = ImageFont.truetype(os.path.join(fonts_dir, ts["font"]), int(round(size * ss)))
    hi = render_glyphs(spec["label"], font, size, w, h, spec["center_x"], top, ts)
    k = size / VAN_SIZE
    images = {}
    for suffix, st in STYLE.items():
        img = compose(hi, w, h, st, k, ss)
        a = np.asarray(img)[..., 3]
        edge = max(a[:, 0].max(), a[:, -1].max())
        if edge > 40:
            print(f"  warning: glow is cut off at the left/right edge (alpha {edge}); widen the image")
        images[suffix] = img
    return images


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--fonts", required=True, help="folder with URWGothic-Demi.ttf and URWGothic-Book.ttf")
    ap.add_argument("--lang", nargs="*", help="languages from buttons.json (default: all)")
    ap.add_argument("--only", nargs="*", help="button names to generate (default: all)")
    ap.add_argument("--out", help="write to <out>/<lang>/ instead of into Resources/")
    args = ap.parse_args()

    with open(os.path.join(HERE, "buttons.json"), encoding="utf-8") as f:
        layout = json.load(f)
    for lang in args.lang or layout:
        if args.out:
            out = os.path.join(args.out, lang)
        else:
            out = os.path.join(REPO, OUTPUT_DIRS.get(
                lang, os.path.join("Resources", "Translations", lang, "Default Theme", "MainMenu")))
        os.makedirs(out, exist_ok=True)
        for name, spec in layout[lang].items():
            if args.only and name not in args.only:
                continue
            print(f"{lang}/{name}: {spec['label']}")
            for suffix, img in make_button(spec, args.fonts).items():
                img.save(os.path.join(out, name + suffix + ".png"))


if __name__ == "__main__":
    main()
