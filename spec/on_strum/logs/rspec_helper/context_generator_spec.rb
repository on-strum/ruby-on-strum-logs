# frozen_string_literal: true

RSpec.describe OnStrum::Logs::RspecHelper::ContextGenerator, type: :helper do
  describe '#random_service_name' do
    it 'returns random service name' do
      expect(::FFaker::InternetSE).to receive(:login_user_name).and_call_original
      expect(random_service_name).to be_an_instance_of(::String)
    end
  end

  describe '#random_semver' do
    it 'returns random semver' do
      expect(::FFaker::SemVer).to receive(:next).and_call_original
      expect(random_semver).to be_an_instance_of(::String)
    end
  end

  describe '#random_message' do
    it 'returns random message' do
      expect(::FFaker::Lorem).to receive(:sentence).and_call_original
      expect(random_message).to be_an_instance_of(::String)
    end
  end

  describe '#create_standard_error' do
    let(:message) { random_message }

    context 'when message is passed' do
      it 'returns StandardError instance with predefined message' do
        expect(::StandardError).to receive(:new).with(message).and_call_original
        exception_instance = create_standard_error(message)
        expect(exception_instance).to be_an_instance_of(::StandardError)
        expect(exception_instance.message).to eq(message)
      end
    end

    context 'when message is not passed' do
      it 'returns StandardError instance with random message' do
        expect(::FFaker::Lorem).to receive(:sentence).and_return(message)
        expect(::StandardError).to receive(:new).with(message).and_call_original
        exception_instance = create_standard_error
        expect(exception_instance).to be_an_instance_of(::StandardError)
        expect(exception_instance.message).to eq(message)
      end
    end
  end

  describe '#random_log_level' do
    it 'returns random log level' do
      expect(random_log_level).to be_an_instance_of(::String)
    end
  end

  describe '#random_datetime' do
    it 'returns random datetime' do
      expect(::FFaker::Time).to receive(:datetime).and_call_original
      expect(random_datetime).to be_an_instance_of(::DateTime)
    end
  end

  describe '#string_with_new_line' do
    it 'returns string with new line at the end' do
      expect(string_with_new_line('a')).to eq("a\n")
    end
  end

  describe '#use_formatter' do
    it 'returns target formatter class' do
      expect(use_formatter(:json)).to eq(OnStrum::Logs::Formatter::Json)
      expect(use_formatter(:detailed)).to eq(OnStrum::Logs::Formatter::Detailed)
      expect(use_formatter(:custom)).to eq(::Class)
    end
  end
end
