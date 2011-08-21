require 'spec_helper'
require 'akki/article'

module Akki
  describe Article do
    it "renders the content" do
      article = Article.new("an article", Date.new(2011, 10, 10), "%p article content", "an-article")
      article.render(nil).should include '<p>article content</p>'
    end

    it "can renders objects passed in" do
      object = mock :object
      object.stub!(:value).and_return "Object Value"
      article = Article.new("an article", Date.new(2011, 10, 10), "= object.value", "an-article")
      article.render(binding).should include "Object Value"
    end

    def article_should_match article, title, date, content, slug
      article.title.should    == title
      article.date.should     == date
      article.content.should  == content
      article.slug.should     == slug
    end

    it "loads all articles" do
      articles = [
        "articles/2012-10-23-article1.txt",
        "articles/2011-11-25-article2.txt"
      ]
      Dir.stub!(:glob).with("articles/*").and_return(articles)
      File.stub!(:read).with(articles.first).and_return("title: article 1\ndate: 2012/10/23\n\narticle 1 content")
      File.stub!(:read).with(articles.last).and_return("title: article 2\ndate: 2011/11/25\n\narticle 2 content")

      article_should_match(Article.all.first, "article 1", Date.new(2012, 10, 23), "article 1 content", "article1")
      article_should_match(Article.all.last, "article 2", Date.new(2011, 11, 25), "article 2 content", "article2")
    end

    it "only loads articles once" do
      articles = [
        "articles/2012-10-23-article1.txt",
        "articles/2011-11-25-article2.txt"
      ]
      Dir.should_receive(:glob).once.and_return(articles)
      File.should_receive(:read).once.and_return("title: article 1\ndate: 2012/10/23\n\narticle 1 content")
      File.should_receive(:read).once.and_return("title: article 2\ndate: 2011/11/25\n\narticle 2 content")
      Article.all
      Article.all
    end

    it "sorts articles by date" do
      articles = [
        "articles/2009-10-23-article1.txt",
        "articles/2011-11-25-article2.txt"
      ]
      Dir.stub!(:glob).with("articles/*").and_return(articles)
      File.stub!(:read).with(articles.first).and_return("title: article 1\ndate: 2009/10/23\n\narticle 1 content")
      File.stub!(:read).with(articles.last).and_return("title: article 2\ndate: 2011/11/25\n\narticle 2 content")

      Article.all.first.title.should == "article 2"
      Article.all.last.title.should == "article 1"
    end

    it "finds an article" do
      articles = [
        Article.new("an article", Date.new(2011, 10, 10), "article 1 content", "an-article"),
        Article.new("Some Article", Date.new(2033, 4, 3), "article 2 content", "some-article")
      ]
      Article.stub!(:all).and_return(articles)
      Article.find(2033, 4, 3, "some-article").should == articles.last
    end

    it "knows it's path" do
      article = Article.new("The best article ever", Date.new(1220, 5, 3), "content", "the-article-slug")
      article.path.should == "/1220/05/03/the-article-slug"
    end
  end
end
