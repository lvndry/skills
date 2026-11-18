---
name: design-inspiration-board
description: Research real, award-level websites and turn them into a mood board of several distinct design directions, each with real reference screenshots and links, a type pairing, a palette, a signature motion and a live animated hero sketch of the user's own product, so the user can pick before anything is fully built. Use whenever someone asks to "propose designs", "give me several options", "find inspiration", "make a moodboard", "I want something very pretty / beautiful / impressive", says a page they got is generic or unimpressive, or is about to start a landing page, marketing site, product page or redesign without a settled visual direction. Also use when the user pastes inspiration gallery links (Awwwards, One Page Love, Landingfolio, Godly, Land-book, SaaS Landing Page) and wants them turned into proposals.
---

# Design inspiration board

People rarely know what they want until they see it, and they can always tell which of several options they prefer. A single finished page, however polished, forces a yes or no on a direction nobody chose. This skill makes the choice first, cheaply and beautifully: research real sites, distil them into five or six clearly different directions, and show each one as a live sketch built from the user's real product, brand and content.

It came out of a session where three finished landing pages were called "not impressive", and a board of six researched directions with live hero sketches got "so much better". `references/lessons.md` records what went wrong and what fixed it. Read it once before your first board.

## The run

### 1. Read the product and the non-negotiables

Before any research, learn what is real and what is fixed:

- What the product is, who it is for, the one thing the page must get someone to do.
- **Hard requirements the user named** (in the source session: "the logo loading animation we have in app"). Find the real implementation in the codebase and reproduce it exactly: same timings, easing, geometry, reduced-motion fallback. Read the code; do not eyeball a screenshot.
- Brand assets that exist: logo files, theme tokens, real screenshots (look in `docs/`, `assets/`, `README` images), real numbers and names from fixtures or demo data.
- Subject-specific material only this product has: its terms of art, its units, its colour systems, its physical world. These become the details that make a direction belong to this product. In the source session the Camelot key wheel's 12 hues, real track names and a BPM of 117.9 did more than any decoration.

Write an inventory of 8 to 12 such items in your notes.

### 2. Research widely, beyond the category

The best references for a music app were general SaaS and product sites, not music sites. Search across categories on purpose.

Use these in order, and stop when you have 15 to 25 strong candidates:

1. **The `inspo` MCP** if it is connected: `recommend` with a one-line brief, then three or four `search_screens` calls with different queries, each a different aesthetic (soft light, dark cinematic, Swiss editorial, playful object, physical artefact). Its rows carry real thumbnails at `https://0nme3pk5am3urwa9.public.blob.vercel-storage.com/captures/<slug>/thumb.384.webp`.
2. **The design-taste-frontend skill's study** if installed: `~/.claude/skills/design-taste-frontend/library/sites.json` holds 181 scored Awwwards and One Page Love sites with a one-line idea each. Sort by score and read the top 40.
3. **Galleries and the web** from `references/resources.md`. Web search returns generic roundups; prefer opening galleries directly. A fetch agent can only read text, so gallery pages give names and URLs, not looks; confirm looks with thumbnails or a browser.
4. **Links the user pastes.** Acknowledge each one, say what you took from it, and say plainly when a source was thin.

For each candidate, note: URL, what is visually distinctive, and which item from your inventory it could carry.

### 3. Cluster into five or six directions

Group candidates into directions that differ on at least two of: light or dark, type class (serif, grotesk, wide, condensed), colour strategy (one accent, colour fields, monochrome), hero device (product window, object, giant type, illustration, interactive toy), and mood (calm, cinematic, playful, editorial, physical).

Always include:

- the direction the user already said they liked, pushed much further;
- one that is calm and very pretty (soft light, serif, sky or paper);
- one that is bold and typographic;
- one built around a physical or printed object from the subject's world;
- one wildcard that is playful or interactive.

`references/direction-archetypes.md` has twelve archetypes with how to sketch each. Name each direction with one or two evocative words (Signal, Daybreak, Afterhours, Crate), not a style label.

### 4. Write each direction card

Each card holds, in this order:

- Letter and name.
- A pitch of two or three sentences in plain language, saying what the visitor sees and feels.
- Inspired by: the real sites, with their gallery score when known.
- Type: the exact Google Fonts families and weights.
- Palette: four to six swatches, taken from the product's own colours where possible.
- Motion: the signature move in one line.
- Three reference thumbnails, each linking to the real site, with a four-word caption of what to take from it.
- Optionally an "Also study" line for strong references without a thumbnail.
- The live sketch.

### 5. Build the live sketches

Start from `assets/board-template.html`. Each sketch is a hero screen at a fixed 1200 by 720 canvas, scaled to its frame with a CSS transform, so absolute positioning is safe and every sketch looks identical at any width. Build each one from the user's real content: real product name, real screenshot, real numbers, real copy. Each must:

- open with the user's hard requirement (for example the logo animation) and then reveal the rest;
- show the direction's signature move running;
- have one interactive detail where it costs little (pads that change a readout, sleeves that flip on click);
- be visible at rest. Play the intro when the frame first enters the viewport (`IntersectionObserver`, threshold 0), never hide content until a high threshold is met, or screenshots and thumbnails show blank frames;
- have a Replay button and a `prefers-reduced-motion` path.

Use only Google Fonts and embed every image as a data URI when publishing as a claude.ai Artifact, whose CSP blocks other hosts. `scripts/build.py` embeds `__EMBED:path__` placeholders.

### 6. Check, then fix

Render the board in a real browser and look at it:

```bash
python3 <skill>/scripts/build.py board.src.html --out board.html --still
node ~/.claude/skills/design-taste-frontend/scripts/inspect.mjs still/index.html   # if installed
```

`--still` writes a copy with every intro transition frozen at its end state, because a scrolling screenshotter captures sketches mid-animation. Look at every sketch for overflow (headlines wrapping into text, giant type wider than the frame, objects pushed off the top), then fix and look once more. Without the inspector, use any headless screenshot or the Chrome tools.

### 7. Present and let them pick

Publish the board (Artifact, or a local HTML file), then reply with one short table: letter, name, the idea in a sentence, main references. Say what each pasted link contributed. End by inviting a letter or a mix ("Daybreak's sky with Signal's curves"). Do not build the full page in the same turn.

### 8. Build the chosen direction

Only after the user picks: build the full page (install, features, screenshots, FAQ) in the chosen direction, carrying its sketch's exact type, palette and motion into every section. If the design-taste-frontend skill is installed, run its gate and look loop on the full page.

## Files

| File | Read it when |
| --- | --- |
| `references/lessons.md` | Before your first board. What failed, what worked, and why. |
| `references/resources.md` | Step 2. Galleries, studied top sites with URLs, fonts, colour, motion and image sources. |
| `references/direction-archetypes.md` | Step 3 and 5. Twelve archetypes with references and sketch recipes. |
| `assets/board-template.html` | Step 5. The board shell: scaled sketch frames, intro and replay, curve engine, reduced motion. |
| `scripts/build.py` | Step 6. Embeds images as data URIs and writes the frozen still copy. |
| `examples/euphoria-directions.src.html` | Any time. The full six-direction board from the source session. |
