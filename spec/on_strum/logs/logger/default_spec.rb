# frozen_string_literal: true

RSpec.describe OnStrum::Logs::Logger::Default do
  describe 'defined constants' do
    it { expect(described_class).to be_const_defined(:LOG_LEVELS) }
  end

  described_class::LOG_LEVELS.each do |method_name|
    describe "##{method_name}" do
      subject(:logger) { described_class.instance.public_send(method_name, log_data) }

      let(:log_data) { {} }
      let(:message) { random_message }

      context 'when onstrum logs not configured' do
        it do
          expect { logger }.to raise_error(
            OnStrum::Logs::Error::Configuration,
            'use OnStrum::Logs.configure before'
          )
        end
      end

      context 'when onstrum logs configured' do
        let(:time) { ::Time.now }

        before do
          stub_time(time)
          init_configuration
        end

        shared_examples 'sends to formatter structured log data' do
          it 'sends to formatter structured log data' do
            expect(current_configuration.formatter)
              .to receive(:call)
              .with(
                time: time,
                level: method_name.to_s.upcase,
                **current_configuration.root_fields,
                **structured_log_data
              )
            logger
          end
        end

        context 'when log data is a Hash' do
          context 'when hash not includes message key' do
            it { expect { logger }.to raise_error(OnStrum::Logs::Error::Logger, 'attribute :message is required') }
          end

          context 'when hash includes only message key' do
            let(:log_data) { { message: message } }
            let(:structured_log_data) do
              {
                message: message,
                context: nil
              }
            end

            include_examples 'sends to formatter structured log data'
          end

          context 'when hash includes not only message key' do
            let(:context) { { attribute: random_message } }
            let(:log_data) { { message: message, **context } }
            let(:structured_log_data) do
              {
                message: message,
                context: context
              }
            end

            include_examples 'sends to formatter structured log data'
          end
        end

        context 'when log data is an Exception' do
          let(:exception) { create_standard_error }
          let(:log_data) { exception }
          let(:structured_log_data) do
            {
              message: "Exception: #{exception.class}",
              context: {
                message: exception.message,
                stack_trace: exception.backtrace
              }
            }
          end

          include_examples 'sends to formatter structured log data'
        end

        context 'when log data is neither a Hash nor an Exception' do
          let(:log_data) { message }
          let(:structured_log_data) do
            {
              message: log_data,
              context: nil
            }
          end

          include_examples 'sends to formatter structured log data'
        end
      end
    end
  end
end
