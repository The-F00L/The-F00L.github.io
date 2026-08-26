# Robert's Journey

Personal portfolio and learning-log site, built with [Jekyll](https://jekyllrb.com/) on the [minimal-mistakes](https://github.com/mmistakes/minimal-mistakes) remote theme. Deployed automatically to GitHub Pages at [the-f00l.github.io](https://the-f00l.github.io).

## Prerequisites

This repo uses [devenv](https://devenv.sh/) (Nix-based) to pin a working Ruby/bundler toolchain, so you don't need a system Ruby install. You'll need:

- [Nix](https://nixos.org/download) with flakes enabled
- [devenv](https://devenv.sh/getting-started/#installation)
- [direnv](https://direnv.net/) (optional but recommended — auto-loads the devenv shell on `cd`)

If direnv is set up, running `direnv allow` once in the repo root is enough; the environment loads automatically from then on. Otherwise, prefix commands with `devenv shell --` or run `devenv shell` to drop into the environment manually.

## Getting started

```bash
# install gems (first time, or after Gemfile changes)
devenv shell -- bundle install

# serve locally with livereload
devenv shell -- bundle exec jekyll serve --livereload
```

The site will be available at `http://127.0.0.1:4000`, and the page auto-refreshes on file changes.

If direnv has loaded the shell for you already, drop the `devenv shell --` prefix and just run `bundle install` / `bundle exec jekyll serve --livereload` directly.

### Without devenv

A plain Ruby + Bundler toolchain works too, as long as your `bundler` version satisfies the one pinned in `Gemfile.lock` (`BUNDLED WITH`):

```bash
gem install bundler -v $(tail -1 Gemfile.lock | tr -d ' ')
bundle install
bundle exec jekyll serve --livereload
```

## Project structure

```
_config.yml       # site configuration
_pages/           # standalone pages (about, certifications, etc.)
_posts/           # blog posts
_data/            # data files consumed by templates
assets/images/    # images, including certification badges under assets/images/certs/
index.markdown    # home page
```

Certification pages live in `_pages/certifications*.md`; each category (AI, cybersecurity, development, devops, IRL, miscellaneous) has its own page linked from `_pages/certifications.md`. Badge images are grouped by category under `assets/images/certs/<category>/`.

## Deployment

Pushing to `master` triggers `.github/workflows/jekyll.yml`, which builds the site with Jekyll and deploys it to GitHub Pages. No manual deploy step is needed.
