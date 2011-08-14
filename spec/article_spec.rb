require 'spec_helper'
require 'akki/article'

module Akki
  describe Article do
    before do
      File.stub!(:read).and_return <<-ARTICLE
      title: the article title
      date: 1983/10/23

      article content
      ARTICLE
    end

    it "reads article content from a file" do
      File.should_receive(:read).with('articles/2011-10-23-article-slug.txt')
      Article.from_file(2011, 10, 23, 'article-slug')
    end

    it "loads the title" do
      article = Article.from_file(2011, 10, 23, 'article-slug')
      article.title.should == 'the article title'
    end

    it "loads the date" do
      article = Article.from_file(2011, 10, 23, 'article-slug')
      article.date.year.should  == 1983
      article.date.month.should == 10
      article.date.day.should   == 23
    end

    it "loads the article content" do
      article = Article.from_file(2011, 10, 23, 'article-slug')
      article.content.should include 'article content'
    end

    it "renders the content" do
      engine = mock :engine
      engine.stub!(:render).and_return 'rendered content'
      Haml::Engine.stub!(:new).and_return(engine)
      article = Article.from_file(2011, 10, 23, 'article-slug')
      article.render.should == 'rendered content'
    end
  end
end
