# Change log

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [v2.1.0](https://github.com/gibbs/puppet-auditd/tree/v2.1.0) (2025-04-26)

[Full Changelog](https://github.com/gibbs/puppet-auditd/compare/v2.0.1...v2.1.0)

### Added

- Remove Puppet 7 support [\#30](https://github.com/gibbs/puppet-auditd/pull/30) ([gibbs](https://github.com/gibbs))

### Fixed

- Explicitly set numeric ordering for rules [\#29](https://github.com/gibbs/puppet-auditd/pull/29) ([gibbs](https://github.com/gibbs))
- Make override.conf world readable [\#25](https://github.com/gibbs/puppet-auditd/pull/25) ([pluijm](https://github.com/pluijm))

## [v2.0.1](https://github.com/gibbs/puppet-auditd/tree/v2.0.1) (2024-11-08)

[Full Changelog](https://github.com/gibbs/puppet-auditd/compare/v2.0.0...v2.0.1)

### Added

- feat: Add Ubuntu 24.04 support [\#24](https://github.com/gibbs/puppet-auditd/pull/24) ([rwaffen](https://github.com/rwaffen))

## [v2.0.0](https://github.com/gibbs/puppet-auditd/tree/v2.0.0) (2024-01-21)

[Full Changelog](https://github.com/gibbs/puppet-auditd/compare/v1.0.4...v2.0.0)

### Added

- Add Debian 12 support [\#23](https://github.com/gibbs/puppet-auditd/pull/23) ([TheMeier](https://github.com/TheMeier))
- Add Puppet 8 support. Drop near EOL versions. [\#22](https://github.com/gibbs/puppet-auditd/pull/22) ([gibbs](https://github.com/gibbs))

## [v1.0.4](https://github.com/gibbs/puppet-auditd/tree/v1.0.4) (2023-10-02)

[Full Changelog](https://github.com/gibbs/puppet-auditd/compare/v1.0.3...v1.0.4)

### Added

- chore: update pdk version 3.0.0 [\#19](https://github.com/gibbs/puppet-auditd/pull/19) ([TheMeier](https://github.com/TheMeier))
- Extend range of order parameter to 1000 [\#16](https://github.com/gibbs/puppet-auditd/pull/16) ([imp-](https://github.com/imp-))
- Update to PDK 2.6.1 [\#15](https://github.com/gibbs/puppet-auditd/pull/15) ([Phil-Friderici](https://github.com/Phil-Friderici))

## [v1.0.3](https://github.com/gibbs/puppet-auditd/tree/v1.0.3) (2023-01-19)

[Full Changelog](https://github.com/gibbs/puppet-auditd/compare/v1.0.2...v1.0.3)

### Added

- Update to PDK 2.6.0 [\#14](https://github.com/gibbs/puppet-auditd/pull/14) ([Phil-Friderici](https://github.com/Phil-Friderici))
- Update actions and dependencies using deprecated node version [\#12](https://github.com/gibbs/puppet-auditd/pull/12) ([gibbs](https://github.com/gibbs))
- Stricter unit tests [\#11](https://github.com/gibbs/puppet-auditd/pull/11) ([Phil-Friderici](https://github.com/Phil-Friderici))

### Fixed

- Fix: Remove hardcoded service\_name and conditionally notify service [\#13](https://github.com/gibbs/puppet-auditd/pull/13) ([gibbs](https://github.com/gibbs))

## [v1.0.2](https://github.com/gibbs/puppet-auditd/tree/v1.0.2) (2022-11-24)

[Full Changelog](https://github.com/gibbs/puppet-auditd/compare/v1.0.1...v1.0.2)

### Added

- Add Ubuntu 22.04 to metadata [\#10](https://github.com/gibbs/puppet-auditd/pull/10) ([Phil-Friderici](https://github.com/Phil-Friderici))

### Fixed

- Raise resource coverage to 100% [\#9](https://github.com/gibbs/puppet-auditd/pull/9) ([Phil-Friderici](https://github.com/Phil-Friderici))
- update pdk + pdk templates [\#8](https://github.com/gibbs/puppet-auditd/pull/8) ([TheMeier](https://github.com/TheMeier))

## [v1.0.1](https://github.com/gibbs/puppet-auditd/tree/v1.0.1) (2022-07-12)

[Full Changelog](https://github.com/gibbs/puppet-auditd/compare/v1.0.0...v1.0.1)

## [v1.0.0](https://github.com/gibbs/puppet-auditd/tree/v1.0.0) (2022-07-12)

[Full Changelog](https://github.com/gibbs/puppet-auditd/compare/v0.9.0...v1.0.0)

### Fixed

- Manage gemfile. Manage lint rules explicitly. [\#7](https://github.com/gibbs/puppet-auditd/pull/7) ([gibbs](https://github.com/gibbs))

## [v0.9.0](https://github.com/gibbs/puppet-auditd/tree/v0.9.0) (2022-04-22)

[Full Changelog](https://github.com/gibbs/puppet-auditd/compare/0.2.0...v0.9.0)

### Added

- Add auditd::audisp for managing the dispatcher on older auditd versions. [\#6](https://github.com/gibbs/puppet-auditd/pull/6) ([gibbs](https://github.com/gibbs))
- Add support for various RedHat family based distros [\#5](https://github.com/gibbs/puppet-auditd/pull/5) ([gibbs](https://github.com/gibbs))
- Add plugin define for managing plugin configuration [\#4](https://github.com/gibbs/puppet-auditd/pull/4) ([gibbs](https://github.com/gibbs))

## [0.2.0](https://github.com/gibbs/puppet-auditd/tree/0.2.0) (2022-03-10)

[Full Changelog](https://github.com/gibbs/puppet-auditd/compare/4ec932c1a3f15bd765d8d3eb262c1682ecdac624...0.2.0)

### Added

- Allow capitalised values. Use capitalised vendor defaults [\#3](https://github.com/gibbs/puppet-auditd/pull/3) ([gibbs](https://github.com/gibbs))
- Add acceptance tests and workflow. Add Debian/Ubuntu config defaults. [\#2](https://github.com/gibbs/puppet-auditd/pull/2) ([gibbs](https://github.com/gibbs))

### Fixed

- Documentation [\#1](https://github.com/gibbs/puppet-auditd/pull/1) ([gibbs](https://github.com/gibbs))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
