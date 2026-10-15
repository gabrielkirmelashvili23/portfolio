# Design System: Gabriel Kirmelashvili, UGC Portfolio

Source of truth for every design decision. Built from Gabriel's mood board (`/design`) plus UI/UX Pro Max (`--design-system`, variance 7 / motion 6 / density 3).

## Direction: "Editorial collage, Apple polish"
- **From the mood board:** cream paper, huge expressive type used as the hero, cut-out photos, asterisk stickers, big chapter numbers (01, 02…), deep red + cobalt blue on cream.
- **From Apple:** generous whitespace, one idea per section, crisp grid, soft and fast motion, big media, nothing cluttered.
- **From UI/UX Pro Max:** pattern = *Scroll-triggered storytelling*: intro hook → numbered chapters → one big closing CTA, with a small CTA at the end of chapters. Type-as-hero. No emoji as icons (SVG only). Respect reduced motion.
- Rejected from the generated system: hot pink palette and Inter-only headings (off-brand vs. the mood board).

## Color tokens (editable in Admin → Site settings → Design)
| Token | Default | Use |
| --- | --- | --- |
| `--paper` | `#F2EDE3` | page background |
| `--ink` | `#1B1F3B` | text, dark surfaces (navy-black) |
| `--accent` | `#C8372D` | vermillion: CTA band, buttons, highlights |
| `--accent-2` | `#4A7BD0` | cobalt: stickers, links, secondary marks |
| `--note` | `#F3D76B` | sticky notes / badges |

Contrast: ink on paper ≈ 14:1; accent on paper ≈ 4.9:1 (OK for UI + large text); paper on accent ≈ 4.9:1.

## Typography
| Role | Font | Notes |
| --- | --- | --- |
| Display | Bricolage Grotesque 700–800, `font-stretch: 75%` | hero name, chapter titles, tight tracking `-0.03em`, line-height 0.9 |
| Serif accent | Instrument Serif italic | taglines, pull quotes |
| Body | Inter 400/500 | 16px+ base, line-height 1.6 |
| Labels | JetBrains Mono 400/500 uppercase, `letter-spacing: .12em` | eyebrows, meta, stats labels |
| Hand | Caveat | photo captions, sticky notes |

Fluid root size: `clamp(16px, 0.35vw + 12px, 26px)` so the same layout scales up for TVs.

## Layout
- Container `76rem`, gutter `clamp(1rem, 4vw, 3rem)`, sections `clamp(5rem, 12vw, 10rem)` apart (density 3 = spacious).
- Breakpoints: 375 / 560 / 820 / 1100 / 1800.
- Video grid: 2 cols (phone) → 3 → 4 → 5 (≥1800px). Always 9:16.

## Motion
- Reveal: fade + 24px rise, 600ms `cubic-bezier(.2,.7,.2,1)`, stagger 60ms via `--i`.
- Hover: 200ms. Exit faster than enter.
- `prefers-reduced-motion`: everything renders in its final state, marquees stop.

## Components
Sticker (SVG asterisk), polaroid, tape, sticky note, chapter header (`01` + eyebrow + title), chip filter (text only), pill button (accent / ghost), marquee band, lightbox.
