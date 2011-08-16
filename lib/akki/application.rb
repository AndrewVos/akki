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

    get "/:page" do
      haml params[:page].to_sym
    end
  end
end
