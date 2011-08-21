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

      @pages = mock :pages
      @pages.stub!(:all).and_return []
    end

    after do
      FileUtils.rm_rf @views_path
      FileUtils.rm_rf @public_path
    end

    def create_view name, contents
      File.open(File.join(@views_path, name), 'w') do |file|
        file.write(contents)
      end
    end

    def create_public name, contents
      File.open(File.join(@public_path, name), 'w') do |file|
        file.write(contents)
      end
    end

    def create_page name, contents
      File.open(File.join(@pages_path, name), 'w') do |file|
        file.write(contents)
      end
    end

    describe "GET /23/10/2011/simple-article" do
      before do
        @article = mock :article
        @article.stub!(:render).and_return 'article content'
        @article.stub!(:title).and_return 'article title'
        Article.stub!(:find).and_return @article
      end

      it "loads an article" do
        create_view "article.haml", ""
        Article.should_receive(:find).with(2011, 10, 23, "simple-article")
        get '/2011/10/23/simple-article'
      end

      it "passes the article through to the view" do
        create_view "article.haml", "= article.render"
        get '/2011/10/23/simple-article'
        last_response.body.should include "article content"
      end

      it "renders the article" do
        create_view 'article.haml', '= article.render'
        get '/2011/10/23/simple-article'
        last_response.body.should include "article content"
      end

      it "passes the settings object through to the article" do
        create_view 'article.haml', '= article.render(settings)'
        Article.stub!(:find).and_return Article.new("article 1", nil, "= settings.title", "article1")
        Application.set :title => "Blog Title"
        get '/2011/10/23/simple-article'
        last_response.body.should include "Blog Title"
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
    end

    describe "GET a page that lists articles" do
      it "lists all articles" do
        Article.stub!(:all).and_return([
          Article.new("article 1", nil, "article 1 content", "article1"),
          Article.new("article 2", nil, "article 2 content", "article2")
        ])

        @pages.stub!(:all).and_return ["archives"]
        Application.set :pages, [:archives]
        create_page 'archives.haml', "- articles.each do |a|\n  %p= a.title"
        Application.set :pages => [:archives]
        get '/archives'
        last_response.body.should include "article 1"
        last_response.body.should include "article 2"
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
