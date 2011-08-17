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
      FileUtils.mkdir_p @views_path
    end

    after do
      FileUtils.rm_rf @views_path
    end

    def create_view name, contents
      File.open(File.join(@views_path, name), 'w') do |file|
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
    end

    describe "GET /page_name" do
      it "renders a custom page" do
        Article.stub!(:all).and_return []
        create_view 'page_name.haml', 'this is my page!'
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
        create_view 'archives.haml', "- articles.each do |a|\n  %p= a.title"
        get '/archives'
        last_response.body.should include "article 1"
        last_response.body.should include "article 2"
      end
    end
  end
end
