# frozen_string_literal: true

RSpec.describe OnStrum::Logs::Formatter::Base do
  describe 'defined constants' do
    it { expect(described_class).to be_const_defined(:DATETIME_FORMAT) }
  end

  describe '.arrange_attrs' do
    subject(:arrange_attrs) { described_class.arrange_attrs(**log_data) }

    let!(:configuration_instance) do
      init_configuration(
        field_name_level: field_name_level,
        field_name_time: field_name_time,
        field_name_message: field_name_message,
        field_name_context: field_name_context
      )
    end

    let(:field_name_level) { :a }
    let(:field_name_time) { :b }
    let(:field_name_message) { :c }
    let(:field_name_context) { :d }
    let(:level) { random_log_level }
    let(:time) { random_datetime }
    let(:message) { random_message }
    let(:context) { nil }
    let(:service_name) { random_service_name }
    let(:service_version) { random_semver }
    let(:log_data) do
      [
        [field_name_level, level],
        [field_name_time, time],
        [:service_name, service_name],
        [:service_version, service_version],
        [field_name_message, message],
        [field_name_context, context]
      ].shuffle.to_h
    end

    it 'arranges log data by predefined order' do
      expect(arrange_attrs.keys).to eq(configuration_instance.log_attributes_order)
    end
  end
end
