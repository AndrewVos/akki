require 'spec_helper'

Akki::Application.set :reload_templates, true

module Akki
  describe Application do
    include Rack::Test::Methods

    def app
      Application
    end

    before do
      @views_path = File.join(File.dirname(__FILE__), '..', 'views')
      @public_path = File.join(File.dirname(__FILE__), '..', 'public')
      @pages_path = File.join(@views_path, 'pages')
      FileUtils.mkdir_p @views_path
      FileUtils.mkdir_p @public_path
      FileUtils.mkdir_p @pages_path
    end

    after do
      FileUtils.rm_rf @views_path
      FileUtils.rm_rf @public_path
    end

    def write_file path, contents
      File.open(path, 'w') do |file|
        file.write(contents)
      end
    end

    def create_view name, contents
      write_file(File.join(@views_path, name), contents)
    end

    def create_public name, contents
      write_file(File.join(@public_path, name), contents)
    end

    def create_page name, contents
      write_file(File.join(@pages_path, name), contents)
    end

    def mock_context(value = "the context value")
      context = Context.new
      context.value = value
      Context.stub!(:new).and_return(context)
      context
    end

    describe "GET /" do
      it "renders the index view" do
        create_page "index.haml", "Home Page"
        get "/"
        last_response.body.should include "Home Page"
      end

      it "passes the context object through to the index view" do
        mock_context
        create_page "index.haml", "= context.value"
        get "/"
        last_response.body.should == "the context value\n"
      end

      it "adds the articles to the context object" do
        context = mock_context
        articles = mock(:articles).as_null_object
        Article.stub!(:all).and_return(articles)
        create_page 'index.haml', 'this is my page!'
        context.should_receive(:articles=).with(articles)
        get "/"
      end
    end

    describe "GET /23/10/2011/simple-article" do
      before do
        @article = mock :article
        @article.stub!(:title).and_return 'article title'
        @article.stub!(:content).and_return 'article content'
        create_page "article.haml", "= render_article(context.article)"
        Article.stub!(:all).and_return([@article])
        Article.stub!(:find).and_return @article
      end

      it "passes the context object through to the article view" do
        mock_context
        create_page("article.haml", "= context.value")
        get '/2011/10/23/simple-article'
        last_response.body.should == "the context value\n"
      end

      it "passes the context object through to the article" do
        mock_context
        @article.stub!(:content).and_return("= context")
        get '/2011/10/23/simple-article'
        last_response.body.should include "the context value"
      end

      it "adds the article to the context object" do
        context = mock_context
        context.article = @article
        context.should_receive(:article=).with(@article)
        get '/2011/10/23/simple-article'
      end

      it "adds the articles to the context object" do
        context = mock_context
        articles = mock(:articles).as_null_object
        Article.stub!(:all).and_return(articles)
        create_page 'page_name.haml', 'this is my page!'
        context.should_receive(:articles=).with(articles)
        get '/2011/10/23/simple-article'
      end

      it "loads an article" do
        create_page "article.haml", ""
        Article.should_receive(:find).with(2011, 10, 23, "simple-article")
        get '/2011/10/23/simple-article'
      end

      it "does not render the layout when rendering the article content" do
        create_view "layout.haml", "Layout\n= yield"
        create_page "article.haml", "Article\n= render_article(context.article)"
        get '/2011/10/23/simple-article'
        last_response.body.should_not include "Layout\nArticle\nLayout\narticle content"
      end
    end

    describe "GET /2011/10/01/article-that-does-not-exist" do
      it "should 404" do
        get '/2011/10/01/article-that-does-not-exist'
        last_response.should be_not_found
      end
    end

    describe "GET /page_name" do
      it "renders a custom page" do
        Application.set :pages, [:page_name]
        Article.stub!(:all).and_return []
        create_page 'page_name.haml', 'this is my page!'
        get '/page_name'
        last_response.body.should include 'this is my page!'
      end

      it "passes the context object through to the page view" do
        mock_context
        Application.set :pages, [:page_name]
        create_page "page_name.haml", "= context.value"
        get '/page_name'
        last_response.body.should == "the context value\n"
      end

      it "adds the articles to the context object" do
        articles = mock(:articles).as_null_object
        mock_context.should_receive(:articles=).with(articles)
        Article.stub!(:all).and_return(articles)
        create_page 'page_name.haml', 'this is my page!'
        get '/page_name'
      end

      context "template name ending in .xml" do
        before do
          create_page "index.xml.haml", "!!! XML"
          Application.set :pages, [:"index.xml"]
        end

        it "sets the content type to xml" do
          get "/index.xml"
          last_response.content_type.should == "application/xml;charset=utf-8"
        end

        it "does not render the layout" do
          create_view "layout.haml", "Layout"
          get "/index.xml"
          last_response.body.should_not include "Layout"
        end
      end
    end

    describe "GET page that doesn't exist" do
      it "404s" do
        get '/page-that-does-not-exist'
        last_response.should be_not_found
      end
    end

    describe "GET file that exists in public folder" do
      it "returns the file" do
        create_public "main.css", "body { }"
        get '/main.css'
        last_response.body.should == "body { }"
      end
    end
  end
end
