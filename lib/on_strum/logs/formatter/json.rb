# frozen_string_literal: true

module OnStrum
  module Logs
    module Formatter
      class Json < Base
        require 'json'

        def self.call(**log_data)
          time_key = OnStrum::Logs.configuration.field_name_time
          json_log = arrange_attrs(
            **log_data,
            time_key => log_data[time_key].strftime(OnStrum::Logs::Formatter::Base::DATETIME_FORMAT)
          ).to_json

          "#{json_log}\n"
        end
      end
    end
  end
end
