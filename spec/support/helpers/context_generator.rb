# frozen_string_literal: true

module OnStrum
  module Logs
    module RspecHelper
      module ContextGenerator
        def random_service_name
          ::FFaker::InternetSE.login_user_name
        end

        def random_semver
          ::FFaker::SemVer.next
        end

        def random_message
          FFaker::Lorem.sentence
        end

        def random_field_name
          FFaker::Lorem.word.to_sym
        end

        def random_root_fields
          ::Array.new(2) { [random_field_name, random_message] }.to_h
        end

        def create_standard_error(message = random_message)
          ::StandardError.new(message)
        end

        def random_log_level
          %w[INFO ERROR DEBUG].sample
        end

        def random_datetime
          FFaker::Time.datetime
        end

        def string_with_new_line(string)
          "#{string}\n"
        end

        def stub_time(stubbed_time)
          allow(::Time).to receive(:now).and_return(stubbed_time)
        end

        def use_formatter(type)
          {
            json: OnStrum::Logs::Formatter::Json,
            detailed: OnStrum::Logs::Formatter::Detailed,
            custom: ::Class
          }[type]
        end
      end
    end
  end
end
