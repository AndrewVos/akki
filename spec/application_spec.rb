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

    describe "GET /" do
      it "renders the index page" do
        create_page "index.haml", "Home Page"
        get "/"
        last_response.body.should include "Home Page"
      end
    end

    describe "GET /23/10/2011/simple-article" do
      before do
        @article = mock :article
        @article.stub!(:title).and_return 'article title'
        @article.stub!(:content).and_return 'article content'
        create_page "article.haml", "= render_article(article)"
        Article.stub!(:all).and_return([@article])
        Article.stub!(:find).and_return @article
      end

      it "loads an article" do
        create_page "article.haml", ""
        Article.should_receive(:find).with(2011, 10, 23, "simple-article")
        get '/2011/10/23/simple-article'
      end

      it "passes the article object through to the article" do
        @article.stub!(:content).and_return '= article.title'
        get '/2011/10/23/simple-article'
        last_response.body.should include "article title"
      end

      it "passes the article object through to the article view" do
        create_page "article.haml", "= article.title"
        get '/2011/10/23/simple-article'
        last_response.body.should include "article title"
      end

      it "does not render the layout when rendering the article content" do
        create_view "layout.haml", "Layout\n= yield"
        create_page "article.haml", "Article\n= render_article(article)"
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

      context "page that lists articles" do
        it "can render articles" do
          Article.stub!(:all).and_return([
            Article.new({:title => "article 1", :date => nil, :content => "%p article 1 content", :slug => "article1"}),
            Article.new({:title => "article 2", :date => nil, :content => "%p article 2 content", :slug => "article2"})
          ])

          create_page 'archives.haml', "- articles.each do |a|\n  = render_article(a)"
          Application.set :pages, [:archives]
          get '/archives'
          last_response.body.should include "<p>article 1 content</p>"
          last_response.body.should include "<p>article 2 content</p>"
        end
      end

      context "template name ending in .xml" do
        before do
          create_page "index.xml.haml", "!!! XML"
          Application.set :pages, [:"index.xml"]
        end

        it "sets the content type to xml" do
          get "/index.xml"
          last_response.content_type.should == "application/atom+xml"
        end

        it "does not render the layout" do
          create_view "layout.haml", "Layout"
          get "/index.xml"
          last_response.body.should_not include "Layout"
        end
      end
    end

    describe "GET page-that-does-not-exist" do
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
