# Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-03-31

### Added

- Added ability to define static fields in the logger document root

```ruby
OnStrum::Logs.configure do |config|
  # Optional parameter. Ability to define static fields in the logger document root.
  # It is equal to empty hash by default.
  config.root_fields = {
    service_name: 'My Great Application',
    service_version: '1.42.0'
  }
```

### Changed

- Changed `OnStrum::Logs.configure`, tests
- Changed `OnStrum::Logs::Configuration`, tests
- Changed `OnStrum::Logs::Logger::Default`, tests
- Changed `OnStrum::Logs::RspecHelper::Configuration`, tests
- Changed `OnStrum::Logs::RspecHelper::ContextGenerator`, tests
- Changed RSpec helpers
- Changed gem development dependencies
- Changed gem documentation

### Removed

- Removed `service_name`, `service_version` required configuration options
- Removed `OnStrum::Logs::RspecHelper::Configuration#complete?`

## [0.3.0] - 2024-03-10

### Added

- Added ability to configure builtin attribute key names

### Changed

- Changed `OnStrum::Logs::Configuration`, tests
- Changed `OnStrum::Logs::Logger::Default`, tests
- Changed `OnStrum::Logs::Formatter::Base`, tests
- Changed `OnStrum::Logs::Formatter::Json`, tests
- Changed `OnStrum::Logs::RspecHelper::Configuration`, tests
- Changed `OnStrum::Logs::RspecHelper::ContextGenerator`, tests
- Changed gem documentation

## [0.2.0] - 2024-03-05

### Added

- Added Ruby 3.3 support
- Added `commitspell` linter

### Changed

- Changed gem development dependencies
- Changed gem documentation, license

## [0.1.1] - 2023-10-18

### Fixed

- Fixed gem class loading

### Changed

- Changed gem documentation

## [0.1.0] - 2023-10-15

### Added

- Added first release of `on_strum-logs`.
