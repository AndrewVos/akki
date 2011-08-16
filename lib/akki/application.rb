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
      article = Article::from_file(year, month, day, slug)
      haml :article, :locals => { :article => article }
    end

    #def render_article article
      #scope = OpenStruct.new
      #scope.article = article
      #layout = File.read('views/layout.haml')
      #article_layout = File.read('views/article.haml')

      #Haml::Engine.new(layout).render(scope) do
        #Haml::Engine.new(article_layout).render(binding)
      #end
    #end
  end
end
