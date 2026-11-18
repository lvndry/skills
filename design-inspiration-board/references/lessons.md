# Lessons from the source session

The session designed a landing page for Euphoria, a free offline desktop app that finds the musical key, tempo and energy of a DJ's tracks. Its one hard requirement was the app's logo loading animation: a 3:2 Lissajous curve drawn tip to tip, held, then erased.

## What fell flat

1. **Three finished pages, built from one quick search.** Dark oscilloscope, light liner notes and warm after-hours, each a complete landing page. The verdict: "not impressed". They were competent and generic: dark grey with a blue glow, a centred product shot, cards. One recommend call and one search is not research.
2. **Category-only references.** Searching "music" and "audio" found record labels and streaming sites, which are poor models for a software landing page. The user had to say "not only audio, there's a lot of beautiful landing pages in all SaaS".
3. **Building before choosing.** Each finished page cost a full build. When the user wanted a different direction, all three builds were wasted.
4. **Hidden-until-scrolled sketches.** Content set to `opacity: 0` until an observer fired at 35% visibility showed as blank frames in screenshots and fast scrolls.
5. **Fonts from blocked hosts.** A direction dealt Boska from Fontshare, which the claude.ai Artifact CSP blocks. Only Google Fonts load there.
6. **Gallery pages read as text.** A fetch agent reading Landingfolio returned names and hex colours, no looks. Galleries need thumbnails or a browser to be useful.

## What worked

1. **A board of six directions with live sketches.** Reaction: "OMGGGG its so much better". The user picked between two favourites (Signal and Daybreak) in one message.
2. **Real references with thumbnails and links,** drawn from general SaaS (Linear, Craft, Arc, Framer), product makers (Teenage Engineering, Fellow), award galleries (Awwwards, One Page Love scored sites) and the subject's own world (record labels).
3. **The hard requirement as the opening of every sketch.** The logo animation, reproduced from the app's source with exact timings (1.6 s draw, 0.5 s hold, 1.2 s erase, cosine ease, round caps, 2.4 s pulse when motion is reduced), opened each sketch. It proved the requirement was understood and tied six different looks to one brand.
4. **The subject as material.** The winning direction drew the logo's 3:2 curve, then the curves of the musical intervals between compatible keys (1:1 circle, 4:3, 6:5, 9:8, and a tritone 45:32 scribble labelled "Clash") in Camelot key colours. Nobody else could have that page. The colour system came from the product's own key hues (oklch, hue = key number × 30°).
5. **Real content in every sketch.** Real screenshots, real track names, real BPMs, honest feature status ("not yet tested" where the README says so).
6. **A frozen still copy for checking.** Freezing transitions at their end state let the screenshots show the real compositions and caught three overflows (a headline running into its paragraph, a giant wordmark wider than the frame, a 3D crate pushing sleeves off the top).
7. **A fixed 1200 by 720 canvas scaled to fit.** Absolute positioning stays exact and every sketch reads the same on a phone, at a smaller scale.

## Rules that follow

- Research at least four aesthetics and at least two categories outside the product's own before proposing anything.
- Propose five or six directions; build none of them fully until the user picks.
- Every sketch carries the user's hard requirement exactly, and uses their real product.
- Keep content visible at rest; animate in on first intersection at threshold 0.
- Google Fonts and data-URI images only when publishing to claude.ai.
- Look at a frozen still render before publishing.
- When the user pastes links, report what each contributed, including "this one was thin".
