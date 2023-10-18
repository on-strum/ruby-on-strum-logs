# `on_strum-logs` - Simple structured logger

[![Maintainability](https://api.codeclimate.com/v1/badges/2f4acd0ca4da58ca3b1e/maintainability)](https://codeclimate.com/github/on-strum/ruby-on-strum-logs/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/2f4acd0ca4da58ca3b1e/test_coverage)](https://codeclimate.com/github/on-strum/ruby-on-strum-logs/test_coverage)
[![CircleCI](https://circleci.com/gh/on-strum/ruby-on-strum-logs/tree/master.svg?style=svg)](https://circleci.com/gh/on-strum/ruby-on-strum-logs/tree/master)
[![Gem Version](https://badge.fury.io/rb/on_strum-logs.svg)](https://badge.fury.io/rb/on_strum-logs)
[![Downloads](https://img.shields.io/gem/dt/on_strum-logs.svg?colorA=004d99&colorB=0073e6)](https://rubygems.org/gems/on_strum-logs)
[![GitHub](https://img.shields.io/github/license/on-strum/ruby-on-strum-logs)](LICENSE.txt)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v1.4%20adopted-ff69b4.svg)](CODE_OF_CONDUCT.md)

Simple configurable structured logger with `JSON` formatter out of the box.

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Configuring](#configuring)
  - [Custom formatter](#custom-formatter)
  - [Resetting configuration](#resetting-configuration)
- [Usage](#usage)
  - [Hash](#hash)
  - [Exception](#exception)
  - [Other](#other)
  - [Debug mode](#debug-mode)
- [Contributing](#contributing)
- [License](#license)
- [Code of Conduct](#code-of-conduct)
- [Credits](#credits)
- [Versioning](#versioning)
- [Changelog](CHANGELOG.md)

## Features

- Structured `JSON` log
- Built-in detailed (debug) formatter
- Ability to configure required parameters
- Ability to configure formatters
- Ability to serialize an exceptions into structured log

## Requirements

Ruby MRI 2.5.0+

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'on_strum-logs'
```

And then execute:

```bash
bundle
```

Or install it yourself as:

```bash
gem install on_strum-logs
```

## Configuring

To start working with this gem, you must configure it first as in the example below:

```ruby
# config/initializers/on_strum_logs.rb

require 'on_strum/logs'

OnStrum::Logs.configure do |config|
  # Required parameter. The current application version.
  config.application_version = '1.42.0'

  # Required parameter. The current application name.
  config.application_name = 'My Great Application'

  # Optional parameter. The colorized structured log in STDOUT. It could be useful
  # for debug mode.
  config.detailed_formatter = true

  # Optional parameter. You can use your custom formatter insted of built-in.
  # Please note, using this option will override using detailed_formatter option.
  config.custom_formatter = YourCustomFormatter
end
```

### Custom formatter

Example of defining custom formatter:

```ruby
YourCustomFormatter = Class.new do
  def self.call(**log_data)
    log_data
  end
end
```

### Resetting configuration

To reset current configuration you can use built-in interface:

```ruby
OnStrum::Logs.reset_configuration!
```

## Usage

In `OnStrum::Logs` supports 3 standard log levels: `INFO`, `ERROR` and `DEBUG`.

```ruby
OnStrum::Logs.info(object)
OnStrum::Logs.error(object)
OnStrum::Logs.debug(object)
```

As methods argument you can use instance of `Hash`, `Exception` or any other class (it will be stringified).

### Hash

Please note, when you uses `Hash`, `:message` is required key. Otherwise you will get an exception.

```ruby
OnStrum::Logs.info(message: 'My Message', some_attribute: 'some attribute')
```

```json
{
  "level": "INFO",
  "time":" 2023-10-15T13:15:21.129+02:00",
  "message": "My Message",
  "context": {
    "some_attribute": "some attribute"
  },
  "service_name": "My Great Application",
  "service_version": "1.42.0"
}
```

### Exception

```ruby
OnStrum::Logs.error(StandardError.new('error message'))
```

```json
{
  "level": "ERROR",
  "time": "2023-10-15T13:32:15.851+02:00",
  "message": "Exception: StandardError",
  "context": {
    "message": "error message",
    "stack_trace": null
  },
  "service_name": "My Great Application",
  "service_version": "1.42.0"
}
```

### Other

```ruby
OnStrum::Logs.debug(42)
```

```json
{
  "level": "DEBUG",
  "time": "2023-10-15T13:33:51.889+02:00",
  "message": "42",
  "context": null,
  "service_name": "My Great Application",
  "service_version": "1.42.0"
}
```

### Debug mode

For view detailed colorized logs you can use configuration option `detailed_formatter = true`:

```ruby
require 'on_strum/logs'

OnStrum::Logs.configure do |config|
  config.application_version = '1.42.0'
  config.application_name = 'My Great Application'
  config.detailed_formatter = true
end

OnStrum::Logs.info(
  message: 'My Message',
  attribute_1: 'attribute 1',
  attribute_2: {
    a: 42,
    b: Class.new
  }
)
```

```bash
{
            :level => "INFO",
            :time  => 2023-10-15 14:02:11.441533 +0200,
          :message => "My Message",
          :context => {
      :attribute_1 => "attribute 1",
      :attribute_2 => {
          :a => 42,
          :b => #<Class:0x0000000103763528> < Object
      }
  },
      :service_name => "My Great Application",
   :service_version => "1.42.0"
}
```

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/on-strum/ruby-on-strum-logs>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct. Please check the [open tickets](https://github.com/on-strum/ruby-on-strum-logs/issues). Be sure to follow Contributor Code of Conduct below and our [Contributing Guidelines](CONTRIBUTING.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the `on_strum-logs` project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](CODE_OF_CONDUCT.md).

## Credits

- [The Contributors](https://github.com/on-strum/ruby-on-strum-logs/graphs/contributors) for code and awesome suggestions
- [The Stargazers](https://github.com/on-strum/ruby-on-strum-logs/stargazers) for showing their support

## Versioning

`on_strum-logs` uses [Semantic Versioning 2.0.0](https://semver.org)
