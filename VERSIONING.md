# Versioning

simple-nfsd uses [Semantic Versioning](https://semver.org/).

| Component | Meaning |
|-----------|---------|
| **MAJOR** | Incompatible protocol or on-disk/config contract changes |
| **MINOR** | Backward-compatible features (often one roadmap milestone) |
| **PATCH** | Fixes and docs inside a milestone |

## Current version

**0.5.0** — see [ROADMAP.md](ROADMAP.md) and [CHANGELOG.md](CHANGELOG.md).

## Rules

- Do not retcon a released tag. Bugfixes after `vX.Y.Z` are `vX.Y.(Z+1)`.
- Keep `CMakeLists.txt` / `VERSION`, packaging, and tags in lockstep for the release you publish.
- Cutting a release: update version files and changelog, commit, `git tag -a vX.Y.Z`, push the tag, create the GitHub Release.
- Detailed acceptance criteria live in [project/ROADMAP_CHECKLIST.md](project/ROADMAP_CHECKLIST.md).

