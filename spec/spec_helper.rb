$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'akki'
require 'rack/test'

Akki::Application::set :environment, :test

RSpec.configure do |config|
  config.before do
    Akki::Article.reload_articles
  end
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
