# frozen_string_literal: true

require_relative 'logs/core'

module OnStrum
  module Logs
    class << self
      def configuration(&block)
        @configuration ||= begin
          return unless block

          OnStrum::Logs::Configuration.new(&block)
        end
      end

      def configure(&block)
        configuration(&block)
      end

      def reset_configuration!
        @configuration = nil
      end

      OnStrum::Logs::Logger::Default::LOG_LEVELS.each do |method|
        define_method(method) do |*arg|
          OnStrum::Logs::Logger::Default.instance.public_send(method, *arg)
        end
      end
    end
  end
end
