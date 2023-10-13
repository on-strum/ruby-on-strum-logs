# frozen_string_literal: true

module OnStrum
  module Logs
    module Formatter
      class Base
        DATETIME_FORMAT = '%FT%T.%3N%:z'
        LOG_ATTRIBUTES_ORDER = %i[level time message context service_name service_version].freeze

        def self.arrange_attrs(**log_data)
          OnStrum::Logs::Formatter::Base::LOG_ATTRIBUTES_ORDER.each_with_object({}) do |attribute, arranged_attrs|
            arranged_attrs[attribute] = log_data[attribute]
          end
        end
      end
    end
  end
end
