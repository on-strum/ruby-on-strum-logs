# frozen_string_literal: true

RSpec.describe OnStrum::Logs::Configuration do
  describe 'defined constants' do
    it { expect(described_class).to be_const_defined(:INCOMPLETE_CONFIG) }
    it { expect(described_class).to be_const_defined(:SETTERS) }
  end

  describe '.new' do
    let(:service_name) { random_service_name }
    let(:service_version) { random_semver }

    context 'when valid configuration' do
      subject(:configuration) do
        create_configuration(
          service_name: service_name,
          service_version: service_version
        )
      end

      it 'creates configuration instance' do
        expect(configuration.service_name).to eq(service_name)
        expect(configuration.service_version).to eq(service_version)
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
    end

    context 'when configuration without block' do
      subject(:configuration) { create_configuration }

      it 'returns configuration instance' do
        expect(configuration.service_name).to be_nil
        expect(configuration.service_version).to be_nil
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
      subject(:configuration) { create_configuration(service_name: random_service_name, service_version: random_semver) }

      it { expect(configuration).to be_complete }
    end
  end
end
