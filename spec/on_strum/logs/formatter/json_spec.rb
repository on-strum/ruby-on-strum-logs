# frozen_string_literal: true

RSpec.describe OnStrum::Logs::Formatter::Json do
  it { expect(described_class).to be < OnStrum::Logs::Formatter::Base }

  describe '.call' do
    subject(:formatter) { described_class.call(**log_data) }

    let(:field_name_level) { :a }
    let(:field_name_time) { :b }
    let(:field_name_message) { :c }
    let(:field_name_context) { :d }
    let(:level) { random_log_level }
    let(:time) { ::Time.new }
    let(:time_formatted) { time.strftime(described_class::DATETIME_FORMAT) }
    let(:message) { random_message }
    let(:context) { nil }
    let(:service_name) { random_service_name }
    let(:service_version) { random_semver }
    let(:log_data) do
      [
        [field_name_level, level],
        [:service_name, service_name],
        [:service_version, service_version],
        [field_name_time, time],
        [field_name_message, message],
        [field_name_context, context]
      ].shuffle.to_h
    end

    before do
      init_configuration(
        field_name_level: field_name_level,
        field_name_time: field_name_time,
        field_name_message: field_name_message,
        field_name_context: field_name_context
      )
    end

    it 'renders arranged log data as json' do
      expect(described_class)
        .to receive(:arrange_attrs)
        .with(log_data.merge(field_name_time => time_formatted))
        .and_call_original
      expect(formatter).to eq(
        string_with_new_line(
          {
            field_name_level => level,
            field_name_time => time_formatted,
            field_name_message => message,
            field_name_context => context,
            service_name: service_name,
            service_version: service_version
          }.to_json
        )
      )
    end
  end
end
