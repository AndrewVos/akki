Feature: Archives
  In order to list all current articles
  As a developer
  I need a list of all articles

  Scenario: View articles sorted by date
    Given I have the article file "1991-04-23-article.txt"
    """
    title: Article 3
    date:  2008/04/23
    """
    And I have the article file "1993-04-23-article.txt"
    """
    title: Article 2
    date:  2008/04/23
    """
    And I have the article file "2008-04-23-article.txt"
    """
    title: Article 1
    date:  2008/04/23
    """
    And I have an archive template that shows the article title
    When I visit "/archives"
    Then I should see:
    """
        <p>Article 1</p>
        <p>Article 2</p>
        <p>Article 3</p>
    """
