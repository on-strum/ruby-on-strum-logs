# frozen_string_literal: true

RSpec.describe OnStrum::Logs::Formatter::Base do
  describe 'defined constants' do
    it { expect(described_class).to be_const_defined(:DATETIME_FORMAT) }
    it { expect(described_class).to be_const_defined(:LOG_ATTRIBUTES_ORDER) }
  end

  describe '.arrange_attrs' do
    subject(:arrange_attrs) { described_class.arrange_attrs(**log_data) }

    let(:level) { random_log_level }
    let(:time) { random_datetime }
    let(:message) { random_message }
    let(:context) { nil }
    let(:service_name) { random_service_name }
    let(:service_version) { random_semver }
    let(:log_data) do
      [
        [:level, level],
        [:time, time],
        [:service_name, service_name],
        [:service_version, service_version],
        [:message, message],
        [:context, context]
      ].shuffle.to_h
    end

    it 'arranges log data by predefined order' do
      expect(arrange_attrs.keys).to eq(described_class::LOG_ATTRIBUTES_ORDER)
    end
  end
end
