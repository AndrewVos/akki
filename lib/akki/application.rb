require 'sinatra/base'
require 'yaml'
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
      layout = File.read('templates/layout.haml')
      Haml::Engine.new(layout).render(binding)
    end
  end
end
