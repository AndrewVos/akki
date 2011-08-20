require 'sinatra/base'
require 'akki/article'

module Akki
  class Application < Sinatra::Base
    set :root, File.join(File.dirname(__FILE__), '..', '..')

    get '/:page_name/?' do
      page_name = params[:page_name].to_sym
      pass unless settings.pages.include? page_name
      haml :"pages/#{page_name}", :locals => { :articles => Article.all }
    end

    get "/:year/:month/:day/:slug/?" do
      year  = params[:year].to_i
      month = params[:month].to_i
      day   = params[:day].to_i
      slug  = params[:slug]
      article = Article::find(year, month, day, slug)
      haml :article, :locals => { :article => article }
    end
  end
end
