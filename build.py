#!/usr/bin/env python3
"""
build.py — Static site generator for gviolato.com
Run: python build.py

Before deploying, fill in the two placeholder keys in docs/index.html
(search for YOUR_WEB3FORMS_ACCESS_KEY and YOUR_TURNSTILE_SITE_KEY):

  1. Web3Forms access key — register at https://web3forms.com
     Replace: YOUR_WEB3FORMS_ACCESS_KEY

  2. Cloudflare Turnstile site key — register at https://dash.cloudflare.com/turnstile
     Replace: YOUR_TURNSTILE_SITE_KEY

These are embedded in the generated HTML. After updating content.py, re-run
this script and the keys in your template will carry through automatically
(they live in templates/index.html, not in content.py).
"""

import os
import shutil
import sys
from pathlib import Path

from jinja2 import Environment, FileSystemLoader

# ---------------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------------
ROOT = Path(__file__).parent.resolve()
TEMPLATES_DIR = ROOT / "templates"
ASSETS_SRC = ROOT / "assets"
DOCS_DIR = ROOT / "docs"
DOCS_ASSETS = DOCS_DIR / "assets"
OUTPUT_HTML = DOCS_DIR / "index.html"
GRAVATAR_SRC = Path("/home/gov/pessoal/gustavo/cv/gravatar.jpeg")
PHOTO_DST = ASSETS_SRC / "images" / "gustavo.jpg"

# ---------------------------------------------------------------------------
# Copy profile photo (silent if missing)
# ---------------------------------------------------------------------------
if GRAVATAR_SRC.exists():
    PHOTO_DST.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(GRAVATAR_SRC, PHOTO_DST)

# ---------------------------------------------------------------------------
# Import content
# ---------------------------------------------------------------------------
sys.path.insert(0, str(ROOT))
from content import SITE, PROFILE, ABOUT, SERVICES, EXPERIENCE, PATENTS, PUBLICATIONS, DEMOS

# ---------------------------------------------------------------------------
# Render template
# ---------------------------------------------------------------------------
env = Environment(loader=FileSystemLoader(str(TEMPLATES_DIR)), autoescape=True)
template = env.get_template("index.html")

photo_exists = (DOCS_ASSETS / "images" / "gustavo.jpg").exists() or PHOTO_DST.exists()

html = template.render(
    site=SITE,
    profile=PROFILE,
    about=ABOUT,
    services=SERVICES,
    experience=EXPERIENCE,
    patents=PATENTS,
    publications=PUBLICATIONS,
    demos=DEMOS,
    photo_exists=photo_exists,
)

# ---------------------------------------------------------------------------
# Write output
# ---------------------------------------------------------------------------
DOCS_DIR.mkdir(exist_ok=True)
OUTPUT_HTML.write_text(html, encoding="utf-8")

# ---------------------------------------------------------------------------
# Copy assets (do NOT clobber hvac-sim/, vaned3/, CNAME)
# ---------------------------------------------------------------------------
if ASSETS_SRC.exists():
    shutil.copytree(str(ASSETS_SRC), str(DOCS_ASSETS), dirs_exist_ok=True)

print(f"Built → {OUTPUT_HTML}")
