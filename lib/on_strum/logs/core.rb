# frozen_string_literal: true

module OnStrum
  module Logs
    module Error
      require_relative 'error/argument_type'
      require_relative 'error/configuration'
    end

    require_relative 'version'
    require_relative 'configuration'
    require_relative '../logs'
  end
end
