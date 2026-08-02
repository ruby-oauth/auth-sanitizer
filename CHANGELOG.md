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

- kettle-jem-template-20260720-005 - README Support & Community links now
  include RubyForum.
- kettle-jem-template-20260726-001 - Projects now include YARD lint
  configuration and documentation dependencies so documentation issues fail
  before generated docs are refreshed.
- kettle-jem-template-20260727-001 - Spec harness documentation now lists the
  RSpec helpers provided by `kettle-test`.

### Changed

- kettle-jem-template-20260716-002 - Generated gemspec manifests now ship fewer
  repository-only files by default to reduce downstream distro packaging churn.

- kettle-jem-template-20260720-002 - Development Gemfiles now use the released
  `tree_sitter_language_pack` gem 1.13.3 or newer by default.
- kettle-jem-template-20260725-002 - Version specs now use `anonymous_loader` to
  cover `version.rb` without redefining constants, or are removed when version
  specs are not managed for the project.
- kettle-jem-template-20260728-001 - Generated Ruby workflows now use clearer
  setup-ruby-flash planning and can prepare appraisal-only jobs without
  installing the main Gemfile bundle.

- kettle-jem-template-20260801-001 - Generated README gem dashboard links now
  use ClickGems instead of BestGems.

### Deprecated

### Removed

### Fixed

- kettle-jem-template-20260720-003 - StructuredMerge Git diff driver config now
  uses the installed `smorg-rb` driver command.
- kettle-jem-template-20260725-001 - Release pull request branches beginning
  with `feature/release` now run JRuby and TruffleRuby workflows.
- kettle-jem-template-20260726-002 - Generated version files now document their
  version namespace and constants, reducing warning-only YARD lint output.
- kettle-jem-template-20260726-003 - Coverage upload steps now treat Coveralls,
  QLTY, and Codecov as optional, so provider outages do not fail CI when local
  coverage thresholds still pass.
- kettle-jem-template-20260728-002 - Generated RuboCop configs now ignore the
  same `gemfiles/vendor/bundle` tree as `.gitignore`, so vendored dependency
  installs are not reported as project lint debt.
- kettle-jem-template-20260728-003 - Generated dep-heads workflows now run
  TruffleRuby jobs with current RubyGems and Bundler, avoiding setup failures
  before the test suite starts.
- kettle-jem-template-20260728-004 - Generated dep-heads workflows now use the
  setup-ruby Bundler install path for direct appraisal Gemfiles, avoiding rv
  lockfile parser failures on Git and path dependencies.
- kettle-jem-template-20260728-005 - VersionGem bootstrap now creates the
  missing canonical version spec when a project only has shim namespace version
  specs.
- kettle-jem-template-20260729-001 - Generated JRuby 9.4 workflows now use the
  legacy manual bundle install path, avoiding setup-time Bundler full-index
  failures against `gem.coop`.
- kettle-jem-template-20260730-001 - Gemspec package file enumeration now runs
  relative to the gemspec directory, so release package contents stay correct
  even when the gemspec is loaded from another working directory.

- kettle-jem-template-20260801-002 - Generated RSpec helpers now normalize
  managed configuration block bindings structurally, preventing mixed block
  parameter names from producing invalid configuration after a merge.
- kettle-jem-template-20260801-003 - Generated project metadata and
  documentation now normalize configured underscore hostnames to valid
  hyphenated hostnames.
- kettle-jem-template-20260801-004 - Generated organization README logos now
  use GitHub's stable organization avatar endpoint instead of assuming a
  matching Galtzo-hosted asset exists.
- kettle-jem-template-20260802-001 - Devcontainer JSON files now merge as JSONC,
  preserving comments and trailing commas during template updates.

### Security

## [0.2.3] - 2026-07-14

- TAG: [v0.2.3][0.2.3t]
- COVERAGE: 85.80% -- 145/169 lines in 7 files
- BRANCH COVERAGE: 82.35% -- 28/34 branches in 7 files
- 84.62% documented

### Added

- Added support for JRuby 10.1 and TruffleRuby 34.0.

### Changed

- Retemplated project metadata and CI/development automation with `kettle-jem` v7.0.0.

### Fixed

- Package configured license files in gem release file lists.

- Removed stale local-path `version_gem` state from the main lockfile.
- Prevented gemspec version detection from defining top-level `Auth` on older
  Rubies.

## [0.2.2] - 2026-06-18

- TAG: [v0.2.2][0.2.2t]
- COVERAGE: 100.00% -- 145/145 lines in 6 files
- BRANCH COVERAGE: 100.00% -- 28/28 branches in 6 files
- 84.62% documented

### Changed

- Documented the released `anonymous_loader` gem as the preferred reusable
  helper for zero-`auth-sanitizer`-namespace loading.

### Fixed

- Documented the `$LOAD_PATH` fallback needed by isolated loader consumers when
  Bundler standalone setup provides `auth_sanitizer/loader.rb` without a
  matching `Gem.loaded_specs` or `GEM_PATH` entry.

## [0.2.1] - 2026-06-06

- TAG: [v0.2.1][0.2.1t]
- COVERAGE: 100.00% -- 145/145 lines in 6 files
- BRANCH COVERAGE: 100.00% -- 28/28 branches in 6 files
- 84.62% documented

### Fixed

- Removed the duplicate RBS declaration for `Auth::Sanitizer::VERSION`, fixing
  `RBS::DuplicatedDeclarationError` in downstream projects.
- Fixed the README support table to list Ruby 2.3 as supported but untested,
  matching the current runtime support and CI policy.

## [0.2.0] - 2026-06-04

- TAG: [v0.2.0][0.2.0t]
- COVERAGE: 100.00% -- 145/145 lines in 6 files
- BRANCH COVERAGE: 100.00% -- 28/28 branches in 6 files
- 84.62% documented

### Changed

- Changed `FilteredAttributes#inspect` to redact narrow patterns from
  `super.inspect` instead of rebuilding object inspect output, preserving host
  inspect behavior.

### Fixed

- Redacted configured attributes inside standard Ruby hash inspect fragments,
  including nested attribute hashes.

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

[Unreleased]: https://github.com/ruby-oauth/auth-sanitizer/compare/v0.2.3...HEAD
[0.2.3]: https://github.com/ruby-oauth/auth-sanitizer/compare/v0.2.2...v0.2.3
[0.2.3t]: https://github.com/ruby-oauth/auth-sanitizer/releases/tag/v0.2.3
[0.2.2]: https://github.com/ruby-oauth/auth-sanitizer/compare/v0.2.1...v0.2.2
[0.2.2t]: https://github.com/ruby-oauth/auth-sanitizer/releases/tag/v0.2.2
[0.2.1]: https://github.com/ruby-oauth/auth-sanitizer/compare/v0.2.0...v0.2.1
[0.2.1t]: https://github.com/ruby-oauth/auth-sanitizer/releases/tag/v0.2.1
[0.2.0]: https://github.com/ruby-oauth/auth-sanitizer/compare/v0.1.5...v0.2.0
[0.2.0t]: https://github.com/ruby-oauth/auth-sanitizer/releases/tag/v0.2.0
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
