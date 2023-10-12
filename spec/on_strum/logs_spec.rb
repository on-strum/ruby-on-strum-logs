# frozen_string_literal: true

RSpec.describe OnStrum::Logs do
  let(:service_name) { random_service_name }
  let(:service_version) { random_semver }

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
            service_name: service_name,
            service_version: service_version
          )
        end

        it 'sets attributes into configuration instance' do
          expect { configuration }
            .to change(described_class, :configuration)
            .from(nil)
            .to(be_instance_of(OnStrum::Logs::Configuration))
          expect(configuration).to be_an_instance_of(OnStrum::Logs::Configuration)
          expect(configuration.service_name).to eq(service_name)
          expect(configuration.service_version).to eq(service_version)
        end
      end

      context 'when configuration is incomplete' do
        let(:config_block) { configuration_block }

        it 'raises configuration error' do
          expect { configuration }.to raise_error(
            OnStrum::Logs::Error::Configuration,
            'service_name, service_version are required parameters'
          )
        end
      end
    end
  end

  describe '.reset_configuration!' do
    before do
      described_class.configure(
        &configuration_block(
          service_name: service_name,
          service_version: service_version
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
        service_name: service_name,
        service_version: service_version
      ))
    end

    it 'returns configuration instance' do
      expect(configuration).to be_instance_of(OnStrum::Logs::Configuration)
      expect(configuration.service_name).to eq(service_name)
      expect(configuration.service_version).to eq(service_version)
    end
  end
end
