# frozen_string_literal: true

rspec_custom = ::File.join(::File.dirname(__FILE__), 'support/**/*.rb')
::Dir[::File.expand_path(rspec_custom)].sort.each { |file| require file unless file[/\A.+_spec\.rb\z/] }

require_relative '../lib/on_strum'

RSpec.configure do |config|
  config.expect_with(:rspec) do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.syntax = :expect
  end

  config.mock_with(:rspec) do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!
  config.order = :random
  config.before { OnStrum::Logs.reset_configuration! }

  config.include OnStrum::Logs::RspecHelper::ContextGenerator
  config.include OnStrum::Logs::RspecHelper::Configuration

  ::Kernel.srand(config.seed)
end
