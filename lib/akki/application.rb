require 'sinatra/base'
require 'akki/article'
require 'ostruct'

module Akki
  class Application < Sinatra::Base
    set :root, File.join(File.dirname(__FILE__), '..', '..')

    get '/?' do
      render_page :"pages/index"
    end

    get '/:page_name/?' do
      page_name = params[:page_name].to_sym
      pass unless settings.pages.include? page_name
      render_page :"pages/#{page_name}"
    end

    get "/:year/:month/:day/:slug/?" do
      year  = params[:year].to_i
      month = params[:month].to_i
      day   = params[:day].to_i
      slug  = params[:slug]
      article = Article::find(year, month, day, slug)
      pass unless article
      render_page :article, {:article => article}
    end

    def render_page page = :index, locals = {}
      default_locals = {:articles => Article.all, :article => nil}
      haml page, :locals => default_locals.merge(locals)
    end

    def render_article article
      haml article.content, :layout => false, :locals => {:article => article}
    end
  end
end
