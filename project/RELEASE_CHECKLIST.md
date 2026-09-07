# simple-nfsd Release Checklist

Use this checklist when preparing a release (currently **v0.5.0**).

## Pre-Release

- [ ] **Build** – configure and build succeeds on at least one primary platform (Linux and/or macOS).
- [ ] **Tests** – `ctest --output-on-failure` passes (or documented exceptions).
- [ ] **Config** – sample configs validate / daemon starts in foreground where applicable.
- [ ] **Docs** – [ROADMAP.md](../ROADMAP.md), [PROJECT_OVERVIEW.md](../PROJECT_OVERVIEW.md), and user docs reflect the release.
- [ ] **CHANGELOG** – [CHANGELOG.md](../CHANGELOG.md) updated with version and date.
- [ ] **Version** – CMake/`VERSION`, packaging, and binary version strings match.
- [ ] **Honesty** – [PROGRESS_REPORT.md](PROGRESS_REPORT.md) reviewed; no overstated production claims.

## Release

- [ ] Tag: `git tag -a v0.5.0 -m "Release v0.5.0"` (adjust version as needed).
- [ ] Create GitHub release with notes from CHANGELOG.
- [ ] Publish build artifacts (packages/binaries) if applicable.
- [ ] Follow [RELEASING.md](../RELEASING.md).

## Post-Release

- [ ] Update [PROJECT_STATUS.md](PROJECT_STATUS.md) and [PROGRESS_REPORT.md](PROGRESS_REPORT.md).
- [ ] Update [ROADMAP_CHECKLIST.md](ROADMAP_CHECKLIST.md) if milestone boundaries changed.
- [ ] Update [PROJECT_OVERVIEW.md](../PROJECT_OVERVIEW.md).

---

**Version:** 0.5.0  
**Last Updated:** August 2026
