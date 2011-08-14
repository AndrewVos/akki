$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))

require 'capybara/cucumber'
require 'akki'

Capybara.app = Akki::Application
Akki::Application.set :environment, :test
