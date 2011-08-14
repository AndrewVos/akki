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
        File.stub!(:read).with('templates/layout.haml').and_return '%div= yield'
        File.stub!(:read).with('templates/article.haml').and_return '%p= article.render'
        Article.stub!(:from_file).and_return @article
      end

      it "is successful" do
        get '/2011/10/23/simple-article'
        last_response.should be_ok
      end

      it "loads an article" do
        Article.should_receive(:from_file).with("2011", "10", "23", 'simple-article')
        get '/2011/10/23/simple-article'
      end

      it "renders the article inside an article template" do
        get '/2011/10/23/simple-article'
        last_response.body.should include '<div><p>article content</p></div>'
      end

      it "passes the article through through to the layout when rendering" do
        File.stub!(:read).with('templates/layout.haml').and_return '= article.title'
        get '/2011/10/23/simple-article'
        last_response.body.should include 'article title'
      end
    end
  end
end
