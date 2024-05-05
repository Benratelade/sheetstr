# frozen_string_literal: true

require "rspec/example_steps"

Dir[Rails.root.join("spec", "support", "**", "*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.include Support::PageFragments
  config.include Support::PageFragments::Login
  config.include Devise::Test::ControllerHelpers, type: :view
  config.include Support::Controllers, type: :controller
end

Capybara.server_port = 5000
