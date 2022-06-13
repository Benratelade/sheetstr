# frozen_string_literal: true

module RSpec
  module Wait
    module Handler
      def handle_matcher(target, *args, &block)
        start_time = Time.now_without_mock_time
        timeout = RSpec.configuration.wait_timeout

        loop do
          actual = target.respond_to?(:call) ? target.call : target
          super(actual, *args, &block)
          break
        rescue RSpec::Expectations::ExpectationNotMetError => e
          elapsed = Time.now_without_mock_time - start_time
          raise e if elapsed > timeout

          sleep RSpec.configuration.wait_delay
          retry
        end
      end

      # From: https://github.com/rspec/rspec-expectations/blob/v3.0.0/lib/rspec/expectations/handler.rb#L44-L63
      class PositiveHandler < RSpec::Expectations::PositiveExpectationHandler
        extend Handler
      end

      # From: https://github.com/rspec/rspec-expectations/blob/v3.0.0/lib/rspec/expectations/handler.rb#L66-L93
      class NegativeHandler < RSpec::Expectations::NegativeExpectationHandler
        extend Handler
      end
    end
  end
end
