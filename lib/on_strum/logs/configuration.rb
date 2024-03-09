# frozen_string_literal: true

module OnStrum
  module Logs
    class Configuration
      INCOMPLETE_CONFIG = 'service_name, service_version are required parameters'
      SETTERS = %i[
        custom_formatter
        service_name
        service_version
        field_name_level
        field_name_time
        field_name_message
        field_name_context
        field_name_exception_message
        field_name_exception_stack_trace
      ].freeze
      BUILTIN_FIELDS_DEFAULT_NAMES = %i[level time message context stack_trace].freeze

      attr_reader(*OnStrum::Logs::Configuration::SETTERS)
      attr_accessor :detailed_formatter

      def initialize(&block)
        instance_initializer.each { |instace_variable, value| instance_variable_set(:"@#{instace_variable}", value) }
        tap(&block) if block
      end

      OnStrum::Logs::Configuration::SETTERS.each do |method|
        define_method(:"#{method}=") do |argument|
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

      # TODO: hardcoded fields will be removed in next release
      def log_attributes_order
        @log_attributes_order ||= OnStrum::Logs::Configuration::SETTERS[3..6].map do |field_name_getter|
          public_send(field_name_getter)
        end + %i[service_name service_version]
      end

      private

      def instance_initializer
        message_key = OnStrum::Logs::Configuration::BUILTIN_FIELDS_DEFAULT_NAMES[2]
        {
          field_name_level: OnStrum::Logs::Configuration::BUILTIN_FIELDS_DEFAULT_NAMES[0],
          field_name_time: OnStrum::Logs::Configuration::BUILTIN_FIELDS_DEFAULT_NAMES[1],
          field_name_message: message_key,
          field_name_context: OnStrum::Logs::Configuration::BUILTIN_FIELDS_DEFAULT_NAMES[3],
          field_name_exception_message: message_key,
          field_name_exception_stack_trace: OnStrum::Logs::Configuration::BUILTIN_FIELDS_DEFAULT_NAMES[4]
        }
      end

      def valid_argument_type?(method_name, argument)
        argument.is_a?(
          case method_name
          when :service_name, :service_version then ::String
          when *OnStrum::Logs::Configuration::SETTERS[3..-1] then ::Symbol
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
