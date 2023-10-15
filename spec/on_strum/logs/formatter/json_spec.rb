# frozen_string_literal: true

RSpec.describe OnStrum::Logs::Formatter::Json do
  describe 'inheritance' do
    it { expect(described_class).to be < OnStrum::Logs::Formatter::Base }
  end

  describe '.call' do
    subject(:formatter) { described_class.call(**log_data) }

    let(:level) { random_log_level }
    let(:time) { ::Time.new }
    let(:time_formatted) { time.strftime(described_class::DATETIME_FORMAT) }
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

    it 'renders arranged log data as json' do
      expect(described_class)
        .to receive(:arrange_attrs)
        .with(log_data.merge(time: time_formatted))
        .and_call_original
      expect(formatter).to eq(
        string_with_new_line(
          {
            level: level,
            time: time_formatted,
            message: message,
            context: context,
            service_name: service_name,
            service_version: service_version
          }.to_json
        )
      )
    end
  end
end
