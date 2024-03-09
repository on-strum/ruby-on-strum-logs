# frozen_string_literal: true

module OnStrum
  module Logs
    module Formatter
      class Base
        DATETIME_FORMAT = '%FT%T.%3N%:z'

        def self.arrange_attrs(**log_data)
          OnStrum::Logs.configuration.log_attributes_order.each_with_object({}) do |attribute, arranged_attrs|
            arranged_attrs[attribute] = log_data[attribute]
          end
        end
      end
    end
  end
end
