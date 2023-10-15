# frozen_string_literal: true

RSpec.describe OnStrum::Logs::Error::Logger do
  it { expect(described_class).to be < ::RuntimeError }

  context 'without argument' do
    subject(:error_instance) { described_class.new }

    it 'includes default error context' do
      expect(error_instance).to be_an_instance_of(described_class)
      expect(error_instance.to_s).to eq('attribute :message is required')
    end
  end

  context 'with argument' do
    subject(:error_instance) { described_class.new(error_context) }

    let(:error_context) { 'some error context' }

    it 'includes error context from argument' do
      expect(error_instance).to be_an_instance_of(described_class)
      expect(error_instance.to_s).to eq(error_context)
    end
  end
end
