require 'sinatra/base'
require 'yaml'
require 'ostruct'
require 'akki/article'

module Akki
  class Application < Sinatra::Base

    get "/:year/:month/:day/:slug/?" do
      year  = params[:year].to_i
      month = params[:month].to_i
      day   = params[:day].to_i
      slug  = params[:slug]
      article = Article::find(year, month, day, slug)
      haml :article, :locals => { :article => article }
    end

    get "/:page/?" do
      haml params[:page].to_sym, :locals => { :articles => Article.all }
    end
  end
end
