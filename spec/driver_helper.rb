# frozen_string_literal: true

require "capybara"
require "selenium-webdriver"
require "webdrivers"

Capybara.default_driver = :selenium_chrome
Capybara.javascript_driver = :selenium
