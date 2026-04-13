# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About

Personal academic/research homepage for Devin Murphy (PhD student at UW ECE), deployed via GitHub Pages.

## Build & Development

Requires **Node.js** (for Eleventy) and **Typst** (for CV PDF). Typst is installed via `winget install Typst.Typst`.

```bash
npm install          # install Node deps (first time)

npm start            # Eleventy dev server with hot reload
npm run build        # compile CV PDF → then build site
npm run build:cv     # compile CV PDF only (typst)
npm run build:eleventy  # build site only (no CV)
```

The `_site/` directory is the build output and is committed to the repo.

## Architecture

**Two distinct parts:**

1. **Main homepage** (`index.html`) — Nunjucks template processed by Eleventy. The Research/publications section is rendered from `_data/publications.yaml`. Everything else (bio, education, experience, more projects) is static HTML in this file.

2. **Blog system** (Eleventy-processed):
   - `blogs.html` — Liquid template listing all posts
   - `posts/<slug>/index.md` — individual posts with frontmatter: `title`, `date`, `layout: post.html`, `permalink`, `summary`
   - `_includes/post.html` — layout template for individual post pages

3. **CV PDF** (`cv/cv.typ`) — Typst template that reads `_data/cv.yaml` and `_data/publications.yaml`. Compiled to `assets/profile/DevinCVLatest.pdf`. The `--root .` flag is required so Typst can read files outside `cv/`.

## Content Management

### Adding / updating a publication

Edit `_data/publications.yaml`. Each entry:

```yaml
- id: unique-slug          # used for bibtex collapse anchor ID
  title: "Full title"
  authors:
    - name: "Author Name"
      url: "https://..."   # optional
      me: true             # bold on website and CV
      equal: true          # adds * superscript
  venue: "CHI 2026"
  venue_url: "https://..."  # optional
  year: 2026
  paper_url: "https://..."
  website_url: "..."        # optional
  code_url: "..."           # optional
  video_url: "..."          # optional
  poster_url: "..."         # optional
  hardware_url: "..."       # optional
  paper_download: true      # adds download attribute (for local PDFs)
  thumbnail: "assets/<proj>/image.png"
  press:                    # optional press coverage
    - name: "Outlet Name"
      url: "https://..."
  bibtex: |                 # optional, literal block
    @misc{key, ...}
  hidden: false             # true = omit from website but keep in CV PDF
  note: "Best Paper Award"  # optional, shown in CV only
```

Then run `npm run build` to regenerate the site and CV.

### Updating CV personal info (education, experience, bio)

Edit `_data/cv.yaml`. Then run `npm run build:cv` for the PDF, or `npm run build` for both.

### Adding a blog post

Create `posts/<slug>/index.md` with frontmatter:

```markdown
---
title: "Post Title"
date: YYYY-MM-DD
layout: post.html
permalink: "/posts/<slug>/"
summary: "One-line description shown in blog listing"
---
```

Any non-`.md` files in `posts/` (images, etc.) are passed through to `_site/` automatically.

## Branches

- `master` — main branch, what GitHub Pages serves
- `html` — active development branch (current)
