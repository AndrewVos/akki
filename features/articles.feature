Feature: Article Page
  In order to display articles
  As a user
  I want to be able to view an article

  Scenario: Simple Article
    Given I have the article file "1983-10-23-simple-article.txt"
    """
    title: Simple Article
    date:  23/10/1983

    %p article content
    """
    When I visit "1983/10/23/simple-article"
    Then I should see:
    """
    <div class='article'><p>article content</p></div>
    """
