# Changelog

[![SemVer 2.0.0][📌semver-img]][📌semver] [![Keep-A-Changelog 1.0.0][📗keep-changelog-img]][📗keep-changelog]

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog][📗keep-changelog],
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html),
and [yes][📌major-versions-not-sacred], platform and engine support are part of the [public API][📌semver-breaking].
Please file a bug if you notice a violation of semantic versioning.

[📌semver]: https://semver.org/spec/v2.0.0.html
[📌semver-img]: https://img.shields.io/badge/semver-2.0.0-FFDD67.svg?style=flat
[📌semver-breaking]: https://github.com/semver/semver/issues/716#issuecomment-869336139
[📌major-versions-not-sacred]: https://tom.preston-werner.com/2022/05/23/major-version-numbers-are-not-sacred.html
[📗keep-changelog]: https://keepachangelog.com/en/1.0.0/
[📗keep-changelog-img]: https://img.shields.io/badge/keep--a--changelog-1.0.0-FFDD67.svg?style=flat

## [Unreleased]

### Added

### Changed

### Deprecated

### Removed

### Fixed

### Security

## [0.1.5] - 2026-06-03

- TAG: [v0.1.5][0.1.5t]
- COVERAGE: 100.00% -- 138/138 lines in 6 files
- BRANCH COVERAGE: 100.00% -- 28/28 branches in 6 files
- 84.62% documented

### Added

- Added `VersionGem::Basic` helpers to `Auth::Sanitizer::Version`.

### Changed

- Refreshed generated package metadata, support documentation, CI workflows,
  and development dependency floors from the current kettle-jem template.
- Documented that CI workflows and appraisals now target MRI Ruby 2.4+ while
  runtime compatibility remains MRI Ruby 2.2+.

### Fixed

- Prevented isolated loader namespace leakage on Ruby 2.5 and older TruffleRuby runtimes.
- Protected the custom gemspec version loader from templating rewrites so
  version detection does not define top-level `Auth` on older Rubies.

## [0.1.4] - 2026-05-21

- TAG: [v0.1.4][0.1.4t]
- COVERAGE: 100.00% -- 135/135 lines in 6 files
- BRANCH COVERAGE: 100.00% -- 28/28 branches in 6 files
- 84.62% documented

### Changed

- (docs) Document constrained `auth-sanitizer` version lookup for isolated loader examples
- (dev) Make templating dependencies opt-in for the main `Gemfile`

### Fixed

- (test) Stop running Appraisal install steps in the locked-deps workflow for the main `Gemfile`

## [0.1.3] - 2026-05-20

- TAG: [v0.1.3][0.1.3t]
- COVERAGE: 100.00% -- 135/135 lines in 6 files
- BRANCH COVERAGE: 100.00% -- 28/28 branches in 6 files
- 84.62% documented

### Added

- Add `AuthSanitizer::Loader.load_isolated` for isolated loading without defining top-level `Auth`
- Document zero-top-level-namespace loading for consumers that need to avoid defining `Auth` or `AuthSanitizer`

## [0.1.2] - 2026-05-15

- TAG: [v0.1.2][0.1.2t]
- COVERAGE: 100.00% -- 134/134 lines in 5 files
- BRANCH COVERAGE: 100.00% -- 28/28 branches in 5 files
- 87.50% documented

### Added

- gemspec description, summary

### Changed

- gemspec contact email

## [0.1.1] - 2026-05-15

- TAG: [v0.1.1][0.1.1t]
- COVERAGE: 100.00% -- 134/134 lines in 5 files
- BRANCH COVERAGE: 100.00% -- 28/28 branches in 5 files
- 87.50% documented

### Added

- Usage documentation in README.md

## [0.1.0] - 2026-05-15

- TAG: [v0.1.0][0.1.0t]
- COVERAGE: 100.00% -- 134/134 lines in 5 files
- BRANCH COVERAGE: 100.00% -- 28/28 branches in 5 files
- 87.50% documented

### Added

- Initial release

[Unreleased]: https://github.com/ruby-oauth/auth-sanitizer/compare/v0.1.5...HEAD
[0.1.5]: https://github.com/ruby-oauth/auth-sanitizer/compare/v0.1.4...v0.1.5
[0.1.5t]: https://github.com/ruby-oauth/auth-sanitizer/releases/tag/v0.1.5
[0.1.4]: https://github.com//ruby-oauth/auth-sanitizer/compare/v0.1.3...v0.1.4
[0.1.4t]: https://github.com//ruby-oauth/auth-sanitizer/releases/tag/v0.1.4
[0.1.3]: https://github.com//ruby-oauth/auth-sanitizer/compare/v0.1.2...v0.1.3
[0.1.3t]: https://github.com//ruby-oauth/auth-sanitizer/releases/tag/v0.1.3
[0.1.2]: https://github.com//ruby-oauth/auth-sanitizer/compare/v0.1.1...v0.1.2
[0.1.2t]: https://github.com//ruby-oauth/auth-sanitizer/releases/tag/v0.1.2
[0.1.1]: https://github.com//ruby-oauth/auth-sanitizer/compare/v0.1.0...v0.1.1
[0.1.1t]: https://github.com//ruby-oauth/auth-sanitizer/releases/tag/v0.1.1
[0.1.0]: https://github.com/ruby-oauth/auth-sanitizer/compare/21d6165dca7eef8e7b9bb01fdfc4cc8bab4e5b96...v0.1.0
[0.1.0t]: https://github.com/ruby-oauth/auth-sanitizer/releases/tag/v0.1.0
