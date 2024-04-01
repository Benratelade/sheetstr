# frozen_string_literal: true

require "capybara"
require "selenium-webdriver"

Capybara.default_driver = :selenium_chrome
Capybara.javascript_driver = :selenium
