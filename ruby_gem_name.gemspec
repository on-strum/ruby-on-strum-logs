# frozen_string_literal: true

require_relative 'lib/ruby_gem_name/version'

Gem::Specification.new do |spec|
  spec.name        = 'ruby_gem_name'
  spec.version     = RubyGemName::VERSION
  spec.authors     = ['FirstName SecondName']
  spec.email       = %w[admin@on-strum.org]

  spec.summary     = %(ruby_gem_name)
  spec.description = %(ruby_gem_name description)

  spec.homepage    = 'https://github.com/on-strum/ruby-gem'
  spec.license     = 'MIT'

  spec.metadata = {
    'homepage_uri' => 'https://github.com/on-strum/ruby-gem',
    'changelog_uri' => 'https://github.com/on-strum/ruby-gem/blob/master/CHANGELOG.md',
    'source_code_uri' => 'https://github.com/on-strum/ruby-gem',
    'documentation_uri' => 'https://github.com/on-strum/ruby-gem/blob/master/README.md',
    'bug_tracker_uri' => 'https://github.com/on-strum/ruby-gem/issues'
  }

  spec.required_ruby_version = '>= 2.5.0'
  spec.files = `git ls-files -z`.split("\x0").select { |f| f.match(%r{^(bin|lib)/|.ruby-version|ruby_gem_name.gemspec|LICENSE}) }
  spec.require_paths = %w[lib]

  spec.add_development_dependency 'rake', '~> 13.0', '>= 13.0.6'
  spec.add_development_dependency 'rspec', '~> 3.12'
end
