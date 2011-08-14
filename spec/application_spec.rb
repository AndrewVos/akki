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
        @article.stub!(:title)
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

      it "returns a template" do
        File.stub!(:read).and_return '%p hello'
        get '/2011/10/23/simple-article'
        last_response.body.should include '<p>hello</p>'
      end
    end
  end
end
