# frozen_string_literal: true

module OnStrum
  module Logs
    module Formatter
      class Detailed < Base
        require 'amazing_print'

        def self.call(**log_data)
          ::Kernel.ap(arrange_attrs(**log_data))
        end
      end
    end
  end
end
