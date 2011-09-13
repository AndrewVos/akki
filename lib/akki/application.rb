require 'sinatra/base'
require 'akki/article'
require 'akki/context'

module Akki
  class Application < Sinatra::Base
    set :root, File.join(File.dirname(__FILE__), '..', '..')

    attr_reader :context

    def create_default_context
      @context = Context.new
      @context.articles = Article.all
    end

    before do
      create_default_context
    end

    get '/?' do
      render_page :index
    end

    get '/:page_name/?' do
      page_name = params[:page_name].to_sym
      pass unless settings.pages.include? page_name
      render_page page_name
    end

    get "/:year/:month/:day/:slug/?" do
      year  = params[:year].to_i
      month = params[:month].to_i
      day   = params[:day].to_i
      slug  = params[:slug]
      article = Article::find(year, month, day, slug)
      pass unless article

      @context.article = article
      render_page :article
    end

    def render_page page = :index
      if page.to_s.end_with? ".xml"
        content_type "application/xml"
        haml :"pages/#{page}", :layout => false, :format => :xhtml, :escape_html => true
      else
        haml :"pages/#{page}"
      end
    end

    def render_article article
      haml article.content, :layout => false
    end
  end
end
