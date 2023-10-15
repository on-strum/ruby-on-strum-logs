# frozen_string_literal: true

module OnStrum
  module Logs
    module Logger
      class Default
        LOG_LEVELS = %i[info error debug].freeze

        def self.instance
          @instance ||= new
        end

        def initialize
          @logger = OnStrum::Logs::Logger::Base.new($stdout, formatter: formatter)
        end

        OnStrum::Logs::Logger::Default::LOG_LEVELS.each do |method_name|
          define_method(method_name) do |arg|
            raise OnStrum::Logs::Error::Configuration unless configuration

            # TODO: we need to have ability to process log data before render it to STDOUT/STDERR
            # hash_normalizer(arg); after_callback.call(arg)
            logger.public_send(method_name, hash_normalizer(arg).merge(level: method_name.to_s.upcase))
          end
        end

        private

        attr_reader :logger

        def configuration
          OnStrum::Logs.configuration
        end

        def formatter
          @formatter ||= proc do |_severity, datetime, _progname, log_data|
            configuration.formatter.call(
              time: datetime,
              service_name: configuration.service_name,
              service_version: configuration.service_version,
              **log_data
            )
          end
        end

        def hash_normalizer(object)
          case object
          when ::Hash
            raise OnStrum::Logs::Error::Logger unless object.key?(:message)

            { message: object.delete(:message), context: (object.empty? ? nil : object) }
          when ::Exception
            {
              message: "Exception: #{object.class}",
              context: {
                message: object.message,
                stack_trace: object.backtrace
              }
            }
          else { message: object.to_s, context: nil }
          end
        end
      end
    end
  end
end
