# frozen_string_literal: true

module OnStrum
  module Logs
    module RspecHelper
      module Configuration
        def configuration_block(**configuration_settings)
          lambda do |config|
            configuration_settings.each do |attribute, value|
              config.public_send(:"#{attribute}=", value)
            end
          end
        end

        def create_configuration(**configuration_settings)
          OnStrum::Logs::Configuration.new(&configuration_block(**configuration_settings))
        end
      end
    end
  end
end
