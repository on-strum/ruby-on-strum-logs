# frozen_string_literal: true

module OnStrum
  module Logs
    module Error
      Logger = ::Class.new(::RuntimeError) do
        def initialize(message = 'attribute :message is required')
          super(message)
        end
      end
    end
  end
end
