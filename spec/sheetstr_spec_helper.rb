# frozen_string_literal: true

Dir[Rails.root.join("spec", "support", "**", "*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.include Support::PageFragments
  config.include Support::PageFragments::Login
end
