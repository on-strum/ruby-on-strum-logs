# frozen_string_literal: true

module OnStrum
  module Logs
    class Configuration
      INCOMPLETE_CONFIG = 'service_name, service_version are required parameters'
      SETTERS = %i[custom_formatter service_name service_version].freeze

      attr_reader(*OnStrum::Logs::Configuration::SETTERS)
      attr_accessor :detailed_formatter

      def initialize(&block)
        tap(&block) if block
      end

      OnStrum::Logs::Configuration::SETTERS.each do |method|
        define_method("#{method}=") do |argument|
          raise_unless(argument, __method__, valid_argument_type?(method, argument))
          instance_variable_set(:"@#{method}", argument)
        end
      end

      def complete?
        !!(service_name && service_version)
      end

      def formatter
        custom_formatter || builded_formatter
      end

      private

      def valid_argument_type?(method_name, argument)
        argument.is_a?(
          case method_name
          when :service_name, :service_version then ::String
          when :custom_formatter then ::Class
          end
        )
      end

      def raise_unless(argument_context, argument_name, condition)
        raise OnStrum::Logs::Error::ArgumentType.new(argument_context, argument_name) unless condition
      end

      def builded_formatter
        return OnStrum::Logs::Formatter::Detailed if detailed_formatter

        OnStrum::Logs::Formatter::Json
      end
    end
  end
end
