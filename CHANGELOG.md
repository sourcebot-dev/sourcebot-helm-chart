# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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