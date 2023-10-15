# frozen_string_literal: true

module OnStrum
  module Logs
    module Error
      require_relative 'error/argument_type'
      require_relative 'error/configuration'
      require_relative 'error/logger'
    end

    module Formatter
      require_relative 'formatter/base'
      require_relative 'formatter/json'
      require_relative 'formatter/detailed'
    end

    require_relative 'version'
    require_relative 'configuration'

    module Logger
      require_relative 'logger/base'
      require_relative 'logger/default'
    end

    require_relative '../logs'
  end
end
