# frozen_string_literal: true

RSpec.describe OnStrum::Logs do
  let(:custom_formatter) { use_formatter(:custom) }
  let(:detailed_formatter) { true }
  let(:root_fields) { random_root_fields }
  let(:field_name_level) { random_field_name }
  let(:field_name_time) { random_field_name }
  let(:field_name_message) { random_field_name }
  let(:field_name_context) { random_field_name }
  let(:field_name_exception_message) { random_field_name }
  let(:field_name_exception_stack_trace) { random_field_name }

  describe '.configure' do
    subject(:configuration) { described_class.configure(&config_block) }

    let(:config_block) { nil }

    context 'without block' do
      it { expect(configuration).to be_nil }
      it { expect { configuration }.not_to change(described_class, :configuration) }
    end

    context 'with block' do
      context 'when configuration is complete' do
        let(:config_block) do
          configuration_block(
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

        it 'sets attributes into configuration instance' do
          expect { configuration }
            .to change(described_class, :configuration)
            .from(nil)
            .to(be_instance_of(OnStrum::Logs::Configuration))
          expect(configuration).to be_an_instance_of(OnStrum::Logs::Configuration)
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
    end
  end

  describe '.reset_configuration!' do
    before do
      described_class.configure(
        &configuration_block(
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
      )
    end

    it do
      expect { described_class.reset_configuration! }
        .to change(described_class, :configuration)
        .from(be_instance_of(OnStrum::Logs::Configuration)).to(nil)
    end
  end

  describe '.configuration' do
    subject(:configuration) { described_class.configuration }

    before do
      described_class.configure(&configuration_block(
        custom_formatter: custom_formatter,
        detailed_formatter: detailed_formatter,
        root_fields: root_fields,
        field_name_level: field_name_level,
        field_name_time: field_name_time,
        field_name_message: field_name_message,
        field_name_context: field_name_context,
        field_name_exception_message: field_name_exception_message,
        field_name_exception_stack_trace: field_name_exception_stack_trace
      ))
    end

    it 'returns configuration instance' do
      expect(configuration).to be_instance_of(OnStrum::Logs::Configuration)
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

  shared_examples 'proxies the call to default logger instance' do
    it 'proxies the call to default logger instance' do
      expect_any_instance_of(OnStrum::Logs::Logger::Default).to receive(target_method).with(arg)
      logger
    end
  end

  shared_examples 'renders logger to stdout represented as json' do
    it 'renders logger to stdout represented as json' do
      expect { logger }.to output(
        find_and_match_json_schema('stdout')
      ).to_stdout_from_any_process
    end
  end

  OnStrum::Logs::Logger::Default::LOG_LEVELS.each do |class_method|
    describe ".#{class_method}" do
      subject(:logger) { described_class.public_send(class_method, arg) }

      let(:target_method) { class_method }
      let(:arg) { { message: random_message, attribute: random_message } }

      before { init_configuration }

      include_examples 'proxies the call to default logger instance'
      include_examples 'renders logger to stdout represented as json'
    end
  end
end
