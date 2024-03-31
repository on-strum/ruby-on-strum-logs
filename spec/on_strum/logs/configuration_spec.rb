# frozen_string_literal: true

RSpec.describe OnStrum::Logs::Configuration do
  describe 'defined constants' do
    it { expect(described_class).to be_const_defined(:SETTERS) }
    it { expect(described_class).to be_const_defined(:BUILTIN_FIELDS_DEFAULT_NAMES) }
  end

  describe '.new' do
    let(:custom_formatter) { use_formatter(:custom) }
    let(:detailed_formatter) { true }
    let(:root_fields) { random_root_fields }
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
          root_fields: root_fields,
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
        expect(configuration.root_fields).to eq(root_fields)
        expect(configuration.field_name_level).to eq(field_name_level)
        expect(configuration.field_name_time).to eq(field_name_time)
        expect(configuration.field_name_message).to eq(field_name_message)
        expect(configuration.field_name_context).to eq(field_name_context)
        expect(configuration.field_name_exception_message).to eq(field_name_exception_message)
        expect(configuration.field_name_exception_stack_trace).to eq(field_name_exception_stack_trace)
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

      context 'when argument root_fields= invalid' do
        subject(:configuration) { create_configuration(root_fields: invalid_argument) }

        let(:expected_error_message) { "#{invalid_argument} is not a valid root_fields=" }

        include_examples 'raies argument error'
      end

      context 'when argument custom_formatter= invalid' do
        subject(:configuration) { create_configuration(custom_formatter: invalid_argument) }

        let(:expected_error_message) { "#{invalid_argument} is not a valid custom_formatter=" }

        include_examples 'raies argument error'
      end

      OnStrum::Logs::Configuration::SETTERS[2..-1].each do |field_name_setter|
        context "when argument #{field_name_setter}= invalid" do
          subject(:configuration) { create_configuration(field_name_setter => invalid_argument) }

          let(:expected_error_message) { "#{invalid_argument} is not a valid #{field_name_setter}=" }

          include_examples 'raies argument error'
        end
      end
    end

    context 'when configuration without block' do
      subject(:configuration) { create_configuration }

      it 'returns incomplete configuration instance' do
        expect(configuration.root_fields).to be_empty
        expect(configuration.custom_formatter).to be_nil
        expect(configuration.field_name_level).to eq(:level)
        expect(configuration.field_name_time).to eq(:time)
        expect(configuration.field_name_message).to eq(:message)
        expect(configuration.field_name_context).to eq(:context)
        expect(configuration.field_name_exception_message).to eq(:message)
        expect(configuration.field_name_exception_stack_trace).to eq(:stack_trace)
        expect(configuration.detailed_formatter).to be_nil
      end
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

    let(:root_fields) { random_root_fields }
    let(:configuration_instance) do
      create_configuration(
        root_fields: root_fields,
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
          *root_fields.keys
        ]
      )
    end
  end
end
