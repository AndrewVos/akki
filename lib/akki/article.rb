require 'haml'

module Akki
  class Article
    attr_accessor :title, :slug, :date, :content

    def initialize(title, date, content, slug)
      @title   = title
      @date    = date
      @content = content
      @slug = slug
    end

    def self.find year, month, day, slug
      article = all.select { |article|
        article.date.year  == year &&
        article.date.month == month &&
        article.date.day   == day &&
        article.slug  == slug
      }.first
    end

    def self.all
      articles = Dir.glob("articles/*").map do |path|
        parts = File.read(path).split("\n\n", 2)
        yaml = YAML.load(parts[0])
        content = parts[1]
        title = yaml['title']
        date  = Date.strptime(yaml['date'], '%Y/%m/%d')
        slug = File.basename(path).split("-", 4).last.gsub(".txt", "")
        Article.new(title, date, content, slug)
      end

      articles = articles.sort do |a, b|
        a.date <=> b.date
      end.reverse
    end

    def render
      Haml::Engine.new(content).render
    end
  end
end
