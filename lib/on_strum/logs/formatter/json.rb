# frozen_string_literal: true

module OnStrum
  module Logs
    module Formatter
      class Json < Base
        require 'json'

        def self.call(time:, **log_data)
          json_log = arrange_attrs(
            time: time.strftime(OnStrum::Logs::Formatter::Base::DATETIME_FORMAT),
            **log_data
          ).to_json

          "#{json_log}\n"
        end
      end
    end
  end
end
