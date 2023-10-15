# frozen_string_literal: true

RSpec::Matchers.define(:find_and_match_json_schema) do |schema_name|
  assertion = JsonMatchers::Assertion.new(schema_name.to_s)

  match do |json|
    assertion.valid?(json[/^\{.*}/])
  end

  if respond_to?(:failure_message)
    failure_message do
      assertion.valid_failure_message
    end

    failure_message_when_negated do
      assertion.invalid_failure_message
    end
  else
    failure_message_for_should do
      assertion.valid_failure_message
    end

    failure_message_for_should_not do
      assertion.invalid_failure_message
    end
  end
end
