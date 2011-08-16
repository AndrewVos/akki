require 'spec_helper'

module Akki
  describe Application do
    include Rack::Test::Methods

    def app
      Application
    end

    describe "GET /23/10/2011/simple-article" do
      before do
        @article = mock :article
        @article.stub!(:render).and_return 'article content'
        @article.stub!(:title).and_return 'article title'

        File.open('views/layout.haml', 'w') do |file|
          file.write("= article.title\n=yield")
        end

        File.open('views/article.haml', 'w') do |file|
          file.write('%p= article.render')
        end
        Article.stub!(:from_file).and_return @article
      end

      it "loads an article" do
        Article.should_receive(:from_file).with("2011", "10", "23", 'simple-article')
        get '/2011/10/23/simple-article'
      end

      it "renders the article inside an article template" do
        get '/2011/10/23/simple-article'
        last_response.body.should include 'article content'
      end

      it "passes the article through to the view when rendering" do
        get '/2011/10/23/simple-article'
        last_response.body.should include 'article title'
      end
    end
  end
end
