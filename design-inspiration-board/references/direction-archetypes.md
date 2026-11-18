# Direction archetypes

Twelve ways a landing page can look, each with references and a recipe for its 1200 by 720 hero sketch. A board picks five or six that differ on light or dark, type class, colour strategy, hero device and mood. The first six were the board in the source session (see `examples/euphoria-directions.src.html`, which builds all six).

## 1. Signal (the brand mark as the show)

Quiet, bright, rich. The product's own mark or a shape from its world is drawn large and live, and variations of it bloom in the product's colours. The user picked this one.
- References: Cursor Compile, Craft, Linear, Highlight.
- Type: a refined grotesk with a width axis, slightly condensed and semibold (Instrument Sans at 85% width).
- Palette: warm off-white `#F6F5F1`, near-black ink, four to six colours from the product's own system.
- Sketch: nav bar; left headline at 92px over three lines max; supporting sentence; two pill buttons; right, the big mark drawing (420px); along the bottom a row of six small variations, each labelled with what it means.
- Motion: the mark draws first, then the variations one after another, offset by about 0.45 s.

## 2. Daybreak (dawn sky)

Soft, emotional, the prettiest. A dawn sky, drifting blurred clouds, a serif headline, the product window floating up from the horizon.
- References: Craft, Arc and Dia, Cluely, Seasats.
- Type: Instrument Serif with italics for display, Inter for text.
- Palette: sky blue `#8DB3E2`, pale blue, peach `#F6D5C2`, navy ink `#13233D`.
- Sketch: layered radial and linear gradients for the sky; three blurred white ellipses drifting 30 to 46 s; centred mark, headline at 88px, sentence and two pills; product screenshot 900px wide from y 486, cropped by the bottom.
- Motion: mark draws in the sky, headline rises, window floats up, clouds drift.

## 3. Afterhours (dark cinematic SaaS)

Dark, precise, confident. A cold light falls on the product, tilted back in perspective, with a light sweeping across it.
- References: Linear, Diffusion Studio, Framer, Raycast.
- Type: Inter Tight 600, tracking -0.045em, a second line in grey.
- Palette: `#07080A`, `#1A1C21`, `#ECEDEF`, one accent from the brand.
- Sketch: radial light cone from the top; status chip with the live mark ("Analysing 48 tracks"); headline at 74px; screenshot in a `perspective` box with `rotateX(24deg)`; a gradient band translating down it as a scan.
- Risk: the most familiar look of the six; it needs a real product idea in the chip and scan to stand out.

## 4. Liner notes, Swiss (giant type and colour fields)

Bold, typographic, editorial. The name set huge in a wide grotesk, with the mark in place of a letter, and chapters as whole fields of colour.
- References: Paul Kalkbrenner, Detroit, University of the Arts London, Thrill Jockey.
- Type: Archivo at `font-stretch: 125%`, weight 800, for titles; normal width for text.
- Palette: white, black, three to five flat field colours from the product.
- Sketch: four-column meta row; the name at about 172px with an SVG mark replacing the O; a strip of 12 colour bars pulsing to the product's tempo; three colour fields at the bottom with one huge figure each.

## 5. Instrument (the product as hardware)

Crafted, playful, precise. The software drawn as a piece of studio hardware with a screen, knobs and pads.
- References: Teenage Engineering, Fellow, Highlight.
- Type: Chivo for labels, Chivo Mono on the device screen.
- Palette: light grey `#D7D8DA`, device white `#EEEEEB`, black screen, pad colours from the product.
- Sketch: top row of five tiny spec columns; a 740 by 420 rounded device in `perspective(1600px) rotateX(16deg) rotateZ(-4deg)`; an inset black screen with the live mark and readouts; six knobs, some turning slowly; twelve coloured pads that change the screen when clicked.

## 6. Crate (physical artefact you flip through)

Warm, physical, playful. Objects from the subject's world (record sleeves, folders, tickets) flip forward one by one.
- References: Third Man Records, Mosby's Files, Daptone, Potion.
- Type: Bricolage Grotesque 800, Inter for text.
- Palette: deep green `#1E3A2C`, paper `#F1EEE6`, crate brown `#8A5A34`, sleeve colours from the product.
- Sketch: headline at 128px on the left; on the right a `perspective` stage with six 400px sleeves stacked by `translateZ`, the front one lifted, cycling every 3.2 s and on click; a spinning disc behind with the mark on its label; the crate front in front of everything.

## 7. Page is the object

The whole page is a printed thing from the subject's world: an invitation, a ticket, a menu, a receipt, a record sleeve. Shaped edges by `clip-path`, never outlined boxes.
- References: Sarah & Matt (the site is the invitation), poetry camera (copy as thermal slips), WeekSync (a coupon with a cut line).
- Sketch: a flat field; one paper panel at believable proportions, cropped by the bottom of the frame; content set as that object is set.

## 8. Toy in the headline

The product's own control sits on the headline and changes it live.
- References: DialKit, Dabbit, Made With GSAP.
- Sketch: a large sentence; two or three floating controls from the product (sliders, dials, a picker) over it; dragging them changes the sentence's weight, colour or content.

## 9. Desktop as stage

For Mac apps: the page is a desktop with a menu bar, windows and files.
- References: heyclicky, CleanShot X, Screen Movie.
- Sketch: menu bar with clock across the top; two or three product windows overlapping; one window animating a real workflow.

## 10. Descent or journey

Scroll is a journey through space or time, with a live instrument counting it.
- References: Applied Imagination (altimeter through clouds), Juggle (the headline drowns).
- Sketch: the first screen of the journey, with the instrument (altimeter, depth gauge, timeline) visible and ticking.

## 11. One word, film title

One word of the name or the destination set a third of the screen tall over footage or a single strong image.
- References: White Desert, PP Neue Montreal.
- Sketch: full-bleed image or looping video; one word at 300px or more; one line of text at the bottom.

## 12. Pixel or grid system

Everything drawn on one visible system: a square-pixel grid, a dithered texture, a drafting grid.
- References: wild, Aspen Search, The New Industrials, PX PUSH.
- Sketch: a canvas-drawn grid or dither field with the name split across cells; one accent colour.
