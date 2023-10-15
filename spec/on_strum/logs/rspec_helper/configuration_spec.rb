# frozen_string_literal: true

RSpec.describe OnStrum::Logs::RspecHelper::Configuration, type: :helper do
  describe '#configuration_block' do
    let(:configuration_params) { { param_one: 1, param_two: 2 } }
    let(:configuration_instance) { ::Struct.new(*configuration_params.keys).new }

    before { configuration_block(**configuration_params).call(configuration_instance) }

    it { expect(configuration_block).to be_an_instance_of(::Proc) }

    it 'sets configuration instance attributes' do
      configuration_params.each do |attribute, value|
        expect(configuration_instance.public_send(attribute)).to eq(value)
      end
    end
  end

  describe '#create_configuration' do
    subject(:configuration_builder) do
      create_configuration(
        service_name: service_name,
        service_version: service_version
      )
    end

    let(:service_name) { random_service_name }
    let(:service_version) { random_semver }

    it 'returns configuration instance with defined params' do
      expect(configuration_builder).to be_an_instance_of(OnStrum::Logs::Configuration)
      expect(configuration_builder.service_name).to eq(service_name)
      expect(configuration_builder.service_version).to eq(service_version)
    end
  end

  describe '#init_configuration' do
    subject(:configuration_initializer) do
      init_configuration(
        custom_formatter: custom_formatter,
        detailed_formatter: detailed_formatter
      )
    end

    let(:custom_formatter) { use_formatter(:json) }
    let(:detailed_formatter) { true }

    it 'initializes configuration instance with random and predefined params' do
      expect(configuration_initializer).to be_an_instance_of(OnStrum::Logs::Configuration)
      expect(configuration_initializer.service_name).not_to be_nil
      expect(configuration_initializer.service_version).not_to be_nil
      expect(configuration_initializer.custom_formatter).to eq(custom_formatter)
      expect(configuration_initializer.detailed_formatter).to eq(detailed_formatter)
    end
  end

  describe '#current_configuration' do
    subject(:current_configuration_instance) { current_configuration }

    it do
      expect(OnStrum::Logs).to receive(:configuration)
      current_configuration_instance
    end
  end
end
