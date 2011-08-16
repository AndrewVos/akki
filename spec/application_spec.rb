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
        Article.stub!(:from_file).and_return @article
      end

      it "loads an article" do
        Article.should_receive(:from_file).with("2011", "10", "23", 'simple-article')
        get '/2011/10/23/simple-article'
      end

      it "renders the article" do
        get '/2011/10/23/simple-article'
        last_response.body.should include 'article content'
      end
    end

    describe "GET /page_name" do
      it "renders a custom page" do
        get '/page_name'
        last_response.body.should include 'this is my page!'
      end
    end
  end
end
