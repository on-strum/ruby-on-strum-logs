# frozen_string_literal: true

RSpec.describe OnStrum::Logs::Logger::Base do
  it { expect(described_class).to be < ::Logger }
end
