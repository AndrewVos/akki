$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))

ENV['RACK_ENV'] = 'test'

require 'capybara/cucumber'
require 'akki'
require 'fileutils'

Capybara.app = Akki::Application
Akki::Application.set :environment, :test
Akki::Application.set :reload_templates, true

Before do
  Akki::Article.reload_articles
end

module Akki
  class Article
    class << self
      def reload_articles
        if defined? @articles
          remove_instance_variable :@articles
        end
      end
    end
  end
end
