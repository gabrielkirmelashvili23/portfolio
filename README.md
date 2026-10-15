# Gabriel Kirmelashvili · UGC Portfolio

Your own portfolio site: your domain, your design, your content.

## Everyday use (no code)

Go to **yourdomain.com/admin**, sign in with GitHub, and:

- **Videos** → *New Video* → upload the MP4, pick a category, save.
- **Photos** → *New Photo* → upload, add a caption, save.
- **Site settings** → change your profile photo, bio, socials, brands, offers, testimonials, or the **Design** (colors, background, font).

Each save updates the live site in about a minute.

Video tip: keep each file under **25 MB**. An MP4 exported from CapCut at 1080p usually fits.

## Where things live

| What | File |
| --- | --- |
| Page layout | `src/pages/index.astro` |
| Styling | `src/styles/global.css` |
| Content (edited by the admin panel) | `src/content/` |
| Uploaded media | `public/media/` |
| Admin panel setup | `public/admin/config.yml` |

## Run it on your computer

```bash
npm install
npm run dev
```

Then open http://localhost:4321 (site) or http://localhost:4321/admin (admin, choose *Work with Local Repository* in Chrome or Edge).

## Hosting

Cloudflare Pages: build command `npm run build`, output folder `dist`.
