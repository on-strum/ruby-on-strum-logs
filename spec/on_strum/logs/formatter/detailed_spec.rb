# frozen_string_literal: true

RSpec.describe OnStrum::Logs::Formatter::Detailed do
  describe 'inheritance' do
    it { expect(described_class).to be < OnStrum::Logs::Formatter::Base }
  end

  describe '.call' do
    subject(:formatter) { described_class.call(**log_data) }

    let(:level) { random_log_level }
    let(:time) { random_datetime }
    let(:message) { random_message }
    let(:context) { nil }
    let(:service_name) { random_service_name }
    let(:service_version) { random_semver }
    let(:log_data) do
      [
        [:level, level],
        [:service_name, service_name],
        [:service_version, service_version],
        [:time, time],
        [:message, message],
        [:context, context]
      ].shuffle.to_h
    end

    it 'sends arranged log data to amazing_print formatter' do
      expect(described_class).to receive(:arrange_attrs).with(log_data).and_call_original
      expect(::Kernel).to receive(:ap).with(log_data)
      formatter
    end
  end
end
