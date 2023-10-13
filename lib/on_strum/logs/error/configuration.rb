# frozen_string_literal: true

module OnStrum
  module Logs
    module Error
      Configuration = ::Class.new(::StandardError) do
        def initialize(message = 'use OnStrum::Logs.configure before')
          super(message)
        end
      end
    end
  end
end
