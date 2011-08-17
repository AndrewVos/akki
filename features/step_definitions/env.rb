$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))

ENV['RACK_ENV'] = 'test'

require 'capybara/cucumber'
require 'akki'
require 'fileutils'

Capybara.app = Akki::Application
Akki::Application.set :environment, :test
