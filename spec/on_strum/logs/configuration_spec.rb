# frozen_string_literal: true

RSpec.describe OnStrum::Logs::Configuration do
  describe 'defined constants' do
    it { expect(described_class).to be_const_defined(:INCOMPLETE_CONFIG) }
    it { expect(described_class).to be_const_defined(:SETTERS) }
    it { expect(described_class).to be_const_defined(:BUILTIN_FIELDS_DEFAULT_NAMES) }
  end

  describe '.new' do
    let(:custom_formatter) { use_formatter(:custom) }
    let(:detailed_formatter) { true }
    let(:service_name) { random_service_name }
    let(:service_version) { random_semver }
    let(:field_name_level) { random_field_name }
    let(:field_name_time) { random_field_name }
    let(:field_name_message) { random_field_name }
    let(:field_name_context) { random_field_name }
    let(:field_name_exception_message) { random_field_name }
    let(:field_name_exception_stack_trace) { random_field_name }

    context 'when valid configuration' do
      subject(:configuration) do
        create_configuration(
          custom_formatter: custom_formatter,
          detailed_formatter: detailed_formatter,
          service_name: service_name,
          service_version: service_version,
          field_name_level: field_name_level,
          field_name_time: field_name_time,
          field_name_message: field_name_message,
          field_name_context: field_name_context,
          field_name_exception_message: field_name_exception_message,
          field_name_exception_stack_trace: field_name_exception_stack_trace
        )
      end

      it 'creates configuration instance' do
        expect(configuration.custom_formatter).to eq(custom_formatter)
        expect(configuration.detailed_formatter).to eq(detailed_formatter)
        expect(configuration.service_name).to eq(service_name)
        expect(configuration.service_version).to eq(service_version)
        expect(configuration.field_name_level).to eq(field_name_level)
        expect(configuration.field_name_time).to eq(field_name_time)
        expect(configuration.field_name_message).to eq(field_name_message)
        expect(configuration.field_name_context).to eq(field_name_context)
        expect(configuration.field_name_exception_message).to eq(field_name_exception_message)
        expect(configuration.field_name_exception_stack_trace).to eq(field_name_exception_stack_trace)
        expect(configuration).to be_complete
      end
    end

    context 'when invalid configuration' do
      shared_examples 'raies argument error' do
        it 'raies argument error' do
          expect { configuration }.to raise_error(
            OnStrum::Logs::Error::ArgumentType,
            expected_error_message
          )
        end
      end

      let(:invalid_argument) { 42 }

      context 'when argument service_name= invalid' do
        subject(:configuration) do
          create_configuration(service_name: invalid_argument, service_version: random_semver)
        end

        let(:expected_error_message) { "#{invalid_argument} is not a valid service_name=" }

        include_examples 'raies argument error'
      end

      context 'when argument service_version= invalid' do
        subject(:configuration) do
          create_configuration(service_name: random_service_name, service_version: invalid_argument)
        end

        let(:expected_error_message) { "#{invalid_argument} is not a valid service_version=" }

        include_examples 'raies argument error'
      end

      context 'when argument custom_formatter= invalid' do
        subject(:configuration) do
          create_configuration(
            custom_formatter: invalid_argument,
            service_name: random_service_name,
            service_version: random_semver
          )
        end

        let(:expected_error_message) { "#{invalid_argument} is not a valid custom_formatter=" }

        include_examples 'raies argument error'
      end

      OnStrum::Logs::Configuration::SETTERS[3..-1].each do |field_name_setter|
        context "when argument #{field_name_setter}= invalid" do
          subject(:configuration) do
            create_configuration(
              service_name: random_service_name,
              service_version: random_semver,
              field_name_setter => invalid_argument
            )
          end

          let(:expected_error_message) { "#{invalid_argument} is not a valid #{field_name_setter}=" }

          include_examples 'raies argument error'
        end
      end
    end

    context 'when configuration without block' do
      subject(:configuration) { create_configuration }

      it 'returns incomplete configuration instance' do
        expect(configuration.service_name).to be_nil
        expect(configuration.service_version).to be_nil
        expect(configuration.custom_formatter).to be_nil
        expect(configuration.field_name_level).to eq(:level)
        expect(configuration.field_name_time).to eq(:time)
        expect(configuration.field_name_message).to eq(:message)
        expect(configuration.field_name_context).to eq(:context)
        expect(configuration.field_name_exception_message).to eq(:message)
        expect(configuration.field_name_exception_stack_trace).to eq(:stack_trace)
        expect(configuration.detailed_formatter).to be_nil
        expect(configuration).not_to be_complete
      end
    end
  end

  describe '#complete?' do
    context 'when required attributes missed' do
      shared_examples 'incomplete configuration' do
        it { expect(configuration).not_to be_complete }
      end

      context 'when service_name is nil' do
        subject(:configuration) { create_configuration }

        it_behaves_like 'incomplete configuration'
      end

      context 'when service_version is nil' do
        subject(:configuration) { create_configuration(service_name: random_service_name) }

        it_behaves_like 'incomplete configuration'
      end
    end

    context 'when required attributes not missed' do
      subject(:configuration) do
        create_configuration(service_name: random_service_name, service_version: random_semver)
      end

      it { expect(configuration).to be_complete }
    end
  end

  describe '#formatter' do
    subject(:formatter) { current_configuration.formatter }

    before { init_configuration(**configuration_attrs) }

    shared_examples 'returns target formatter' do
      it { is_expected.to eq(expected_formatter) }
    end

    context 'when json formatter enabled' do
      let(:configuration_attrs) { {} }
      let(:expected_formatter) { use_formatter(:json) }

      include_examples 'returns target formatter'
    end

    context 'when detailed formatter enabled' do
      let(:configuration_attrs) { { detailed_formatter: true } }
      let(:expected_formatter) { use_formatter(:detailed) }

      include_examples 'returns target formatter'
    end

    context 'when defined custom formatter' do
      let(:configuration_attrs) { { custom_formatter: expected_formatter } }
      let(:expected_formatter) { use_formatter(:custom) }

      include_examples 'returns target formatter'
    end

    context 'when defined custom formatter, detailed formatter enabled' do
      let(:configuration_attrs) { { custom_formatter: expected_formatter, detailed_formatter: true } }
      let(:expected_formatter) { use_formatter(:custom) }

      include_examples 'returns target formatter'
    end
  end

  describe '#log_attributes_order' do
    subject(:log_attributes_order) { configuration_instance.log_attributes_order }

    let(:configuration_instance) do
      create_configuration(
        field_name_level: random_field_name,
        field_name_time: random_field_name,
        field_name_message: random_field_name,
        field_name_context: random_field_name
      )
    end

    it 'returns log attributes order' do
      expect(log_attributes_order).to eq(
        [
          configuration_instance.field_name_level,
          configuration_instance.field_name_time,
          configuration_instance.field_name_message,
          configuration_instance.field_name_context,
          :service_name,
          :service_version
        ]
      )
    end
  end
end
