# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.98] - 2026-07-24

### Changed
- Bumped Sourcebot to v5.1.4. [Release notes](https://github.com/sourcebot-dev/sourcebot/releases/tag/v5.1.4)

## [0.1.97] - 2026-07-20

### Changed
- Bumped Sourcebot to v5.1.3. [Release notes](https://github.com/sourcebot-dev/sourcebot/releases/tag/v5.1.3)

## [0.1.96] - 2026-07-20

### Fixed
- PostgreSQL connections now respect `postgresql.port`, while preserving ports already included in `postgresql.host`. [#123](https://github.com/sourcebot-dev/sourcebot-helm-chart/pull/123)

## [0.1.95] - 2026-07-16

### Changed
- Bumped Sourcebot to v5.1.2. [Release notes](https://github.com/sourcebot-dev/sourcebot/releases/tag/v5.1.2)

## [0.1.94] - 2026-07-14

### Changed
- Bumped Sourcebot to v5.1.1. [Release notes](https://github.com/sourcebot-dev/sourcebot/releases/tag/v5.1.1)

## [0.1.93] - 2026-07-10

### Changed
- Bumped Sourcebot to v5.1.0. [Release notes](https://github.com/sourcebot-dev/sourcebot/releases/tag/v5.1.0)

## [0.1.92] - 2026-06-18

### Changed
- Bumped Sourcebot to v5.0.4. [Release notes](https://github.com/sourcebot-dev/sourcebot/releases/tag/v5.0.4)

## [0.1.91] - 2026-06-17

### Changed
- Bumped Sourcebot to v5.0.3. [Release notes](https://github.com/sourcebot-dev/sourcebot/releases/tag/v5.0.3)

## [0.1.90] - 2026-06-11

### Changed
- Bumped Sourcebot to v5.0.2. [Release notes](https://github.com/sourcebot-dev/sourcebot/releases/tag/v5.0.2)

## [0.1.89] - 2026-06-09

### Added
- Support for root-level `additionalLabels` and `global.metadata` passthrough. [#103](https://github.com/sourcebot-dev/sourcebot-helm-chart/pull/103)

### Fixed
- `sourcebot.additionalLabels` are now applied to resources (previously silently ignored). [#103](https://github.com/sourcebot-dev/sourcebot-helm-chart/pull/103)
- Helm upgrade failure caused by the data PVC's immutable `volumeName`; the PVC now retains its bound volume and is preserved across upgrades (`helm.sh/resource-policy: keep`). [#102](https://github.com/sourcebot-dev/sourcebot-helm-chart/pull/102)

## [0.1.88] - 2026-06-04

### Changed
- Bumped Sourcebot to v5.0.1. [Release notes](https://github.com/sourcebot-dev/sourcebot/releases/tag/v5.0.1)

## [0.1.87] - 2026-06-04

### Changed
- Bumped Sourcebot to v5.0.0. [Release notes](https://github.com/sourcebot-dev/sourcebot/releases/tag/v5.0.0)

## [0.1.86] - 2026-06-02

### Added
- `sourcebot.lifecycle` and `sourcebot.terminationGracePeriodSeconds` values. [#110](https://github.com/sourcebot-dev/sourcebot-helm-chart/pull/110)

## [0.1.85] - 2026-05-30

### Changed
- Bumped Sourcebot to v4.17.4. [Release notes](https://github.com/sourcebot-dev/sourcebot/releases/tag/v4.17.4)

## [0.1.84] - 2026-05-22

### Changed
- Bumped Sourcebot to v4.17.3. [Release notes](https://github.com/sourcebot-dev/sourcebot/releases/tag/v4.17.3)

## [0.1.83] - 2026-05-16

### Changed
- Bumped Sourcebot to v4.17.2. [Release notes](https://github.com/sourcebot-dev/sourcebot/releases/tag/v4.17.2)

## [0.1.82] - 2026-05-04

### Changed
- Bumped Sourcebot to v4.17.1. [Release notes](https://github.com/sourcebot-dev/sourcebot/releases/tag/v4.17.1)

## [0.1.81] - 2026-04-30

### Changed
- Bumped Sourcebot to v4.17.0. [Release notes](https://github.com/sourcebot-dev/sourcebot/releases/tag/v4.17.0)

## [0.1.80] - 2026-04-23

### Changed
- Bumped Sourcebot to v4.16.15. [Release notes](https://github.com/sourcebot-dev/sourcebot/releases/tag/v4.16.15)

## [0.1.79] - 2026-04-21

### Changed
- Bumped Sourcebot to v4.16.14. [Release notes](https://github.com/sourcebot-dev/sourcebot/releases/tag/v4.16.14)

## [0.1.78] - 2026-04-21

### Changed
- Bumped Sourcebot to v4.16.13. [Release notes](https://github.com/sourcebot-dev/sourcebot/releases/tag/v4.16.13)

## [0.1.77] - 2026-04-20

### Changed
- Bumped Sourcebot to v4.16.12. [Release notes](https://github.com/sourcebot-dev/sourcebot/releases/tag/v4.16.12)

## [0.1.76] - 2026-04-17

### Changed
- Bumped Sourcebot to v4.16.11. [Release notes](https://github.com/sourcebot-dev/sourcebot/releases/tag/v4.16.11)

## [0.1.75] - 2026-04-16

### Changed
- Bumped Sourcebot to v4.16.10. [Release notes](https://github.com/sourcebot-dev/sourcebot/releases/tag/v4.16.10)

## [0.1.74] - 2026-04-15

### Changed
- Bumped Sourcebot to v4.16.9. [Release notes](https://github.com/sourcebot-dev/sourcebot/releases/tag/v4.16.9)

## [0.1.73] - 2026-04-09

### Changed
- Bumped Sourcebot to v4.16.8. [Release notes](https://github.com/sourcebot-dev/sourcebot/releases/tag/v4.16.8)

## [0.1.72] - 2026-04-09

### Added
- Added configurable deployment strategy support, allowing users to switch between `RollingUpdate` and `Recreate` strategies. [#82](https://github.com/sourcebot-dev/sourcebot-helm-chart/pull/82)

## [0.1.71] - 2026-04-09

### Added
- Added default resource requests/limits for Sourcebot (2 CPU/4Gi), PostgreSQL (2 CPU/4Gi), and Redis (1 CPU/1.5Gi). [#88](https://github.com/sourcebot-dev/sourcebot-helm-chart/pull/88)
- Added `sourcebot.authSecret` and `sourcebot.encryptionKey` fields to values.yaml, supporting both direct values and existing secret references. [#88](https://github.com/sourcebot-dev/sourcebot-helm-chart/pull/88)

### Fixed
- Fixed PostgreSQL `secretKeys` defaults to match Bitnami-generated key names (`password`/`postgres-password`), fixing helm upgrade failures. [#88](https://github.com/sourcebot-dev/sourcebot-helm-chart/pull/88)
- Fixed Redis subchart key from `master` to `primary` to match Bitnami Valkey chart (resources were not being applied). [#88](https://github.com/sourcebot-dev/sourcebot-helm-chart/pull/88)
