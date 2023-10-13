# frozen_string_literal: true

require_relative 'lib/on_strum/logs/version'

Gem::Specification.new do |spec|
  spec.name        = 'on_strum-logs'
  spec.version     = OnStrum::Logs::VERSION
  spec.authors     = ['Vladislav Trotsenko']
  spec.email       = %w[admin@on-strum.org]

  spec.summary     = %(on_strum-logs)
  spec.description = %(Simple structured logger)

  spec.homepage    = 'https://github.com/on-strum/ruby-on-strum-logs'
  spec.license     = 'MIT'

  spec.metadata    = {
    'homepage_uri'      => 'https://github.com/on-strum/ruby-on-strum-logs',
    'changelog_uri'     => 'https://github.com/on-strum/ruby-on-strum-logs/blob/master/CHANGELOG.md',
    'source_code_uri'   => 'https://github.com/on-strum/ruby-on-strum-logs',
    'documentation_uri' => 'https://github.com/on-strum/ruby-on-strum-logs/blob/master/README.md',
    'bug_tracker_uri'   => 'https://github.com/on-strum/ruby-on-strum-logs/issues'
  }

  spec.required_ruby_version = '>= 2.5.0'
  spec.files = `git ls-files -z`.split("\x0").select { |f| f.match(%r{^(bin|lib)/|.ruby-version|on_strum-logs.gemspec|LICENSE}) }
  spec.require_paths = %w[lib]

  spec.add_runtime_dependency 'amazing_print', '~> 1.5'

  spec.add_development_dependency 'ffaker', '~> 2.21'
  spec.add_development_dependency 'rake', '~> 13.0', '>= 13.0.6'
  spec.add_development_dependency 'rspec', '~> 3.12'
end
