require 'spec_helper'

module Akki
  describe Application do
    include Rack::Test::Methods

    def app
      Application
    end

    before do
      Application.set :views, "spec/fixtures/views"
    end

    describe "GET /23/10/2011/simple-article" do
      before do
        @article = mock :article
        @article.stub!(:render).and_return 'article content'
        @article.stub!(:title).and_return 'article title'
        Article.stub!(:find).and_return @article
      end

      it "loads an article" do
        Article.should_receive(:find).with(2011, 10, 23, "simple-article")
        get '/2011/10/23/simple-article'
      end

      it "renders the article" do
        get '/2011/10/23/simple-article'
        last_response.body.should include 'article content'
      end
    end

    describe "GET /page_name" do
      it "renders a custom page" do
        Article.stub!(:all).and_return []
        get '/page_name'
        last_response.body.should include 'this is my page!'
      end
    end

    describe "GET a page that lists articles" do
      it "lists all articles" do
        Article.stub!(:all).and_return([
         Article.new("article 1", nil, nil, "article1"),
         Article.new("article 2", nil, nil, "article2")
        ])
        get '/archives'
        last_response.body.should include "article 1"
        last_response.body.should include "article 2"
      end
    end

  end
end
