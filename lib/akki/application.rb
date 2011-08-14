require 'sinatra/base'
require 'yaml'
require 'ostruct'
require 'akki/article'

module Akki
  class Application < Sinatra::Base
    get "/:year/:month/:day/:slug/?" do
      year  = params[:year]
      month = params[:month]
      day   = params[:day]
      slug  = params[:slug]
      render(Article::from_file(year, month, day, slug))
    end

    def render article
      scope = OpenStruct.new
      scope.article = article
      layout = File.read('templates/layout.haml')
      article_layout = File.read('templates/article.haml')

      Haml::Engine.new(layout).render(scope) do
        Haml::Engine.new(article_layout).render(binding)
      end
    end
  end
end
