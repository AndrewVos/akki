$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'akki'
require 'rack/test'

Akki::Application::set :environment, :test
