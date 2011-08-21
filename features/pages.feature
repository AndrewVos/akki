Feature: Pages
  In order to display custom pages
  As a blogger
  I want to display custom pages

  Scenario: Page
    Given I have the page "example-page.haml" with the contents
    """
    %p This is the example page
    """
    When I visit "/example-page"
    Then I should see:
    """
    <p>This is the example page</p>
    """

  Scenario: Page that doesn't exist
    When I visit "/page-that-does-not-exist/"
    Then I should see a 404 html status code

  Scenario: Arbitrary articles can be rendered on a page
    Given I have the article file "1983-05-23-simple-article.txt"
    """
    title: Simple Article
    date:  1983/05/23

    %p article content
    """
    And I have the article file "1982-04-01-arbitrary-article.txt"
    """
    title: Arbitrary Article
    date:  1982/04/01

    %p arbitrary article content
    """
    And I have the page "article.haml" with the contents
    """
    Article
    = render_article(articles.last)
    """
    When I visit "/1983/05/23/simple-article"
    Then I should see:
    """
    Article
    <p>arbitrary article content</p>
    """
