require 'haml'

module Akki
  class Article
    attr_accessor :title, :date, :content

    def initialize(title, date, content)
      @title   = title
      @date    = date
      @content = content
    end

    def self.from_file year, month, day, slug
      path = "articles/#{year}-#{month}-#{day}-#{slug}.txt"
      parts = File.read(path).split("\n\n", 2)
      yaml = YAML.parse(parts[0])
      content = parts[1]
      title = yaml['title'].value
      date  = Date.strptime(yaml['date'].value, '%Y/%m/%d')
      Article.new(title, date, content)
    end

    def render
      Haml::Engine.new(content).render
    end
  end
end
