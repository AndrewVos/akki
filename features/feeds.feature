Feature: Feeds
  In order to notify users when there are new blog entries
  As a blogger
  I want to be able to expose my rss feeds

  Scenario: Index page
    Given I have the page "index.xml.haml" with the contents
    """
    !!! XML
    %feed{:xmlns => "http://www.w3.org/2005/Atom"}
      %title
        = settings.title
      %id http://example.org
      %updated
        = articles.first.date.iso8601
    """
    And I have the article file "1983-05-23-simple-article.txt"
    """
    title: Simple Article
    date:  1983/05/23

    %p article content
    """
    When I visit "/index.xml"
    Then I should see:
    """
    <?xml version='1.0' encoding='utf-8' ?>
    <feed xmlns='http://www.w3.org/2005/Atom'>
      <title>
        The Blog Title
      </title>
      <id>http://example.org</id>
      <updated>
        1983-05-23
      </updated>
    </feed>
    """
