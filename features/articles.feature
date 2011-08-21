Feature: Article Page
  In order to display articles
  As a user
  I want to be able to view an article and it's relevant information

  Scenario: Article url that does not exist
    When I visit "/1983/11/11/article-that-does-not-exist"
    Then I should see a 404 html status code

  Scenario: Simple Article
    Given I have the article file "1983-05-23-simple-article.txt"
    """
    title: Simple Article
    date:  1983/05/23

    %p article content
    """
    And the article view:
    """
    %div.title= article.title
    %div.content= content
    %a{:href => article.path}
    """
    When I visit "/1983/05/23/simple-article"
    Then I should see:
    """
    <div class='title'>Simple Article</div>
    <div class='content'><p>article content</p></div>
    <a href='/1983/05/23/simple-article'></a>
    """

  Scenario: Article referencing context object
    Given I have the article file "1983-05-23-simple-article.txt"
    """
    title: Simple Article
    date:  1983/05/23

    = settings.title
    = article.title
    """
    And the application setting "title" with the value "The Blog Title"
    And the article view:
    """
    = content
    """
    And the application setting "title" with the value "The Blog Title"
    When I visit "/1983/05/23/simple-article"
    Then I should see:
    """
    The Blog Title
    Simple Article
    """

  Scenario: Article does not get rendered with the layout
    Given I have the article file "1983-05-23-simple-article.txt"
    """
    title: Simple Article
    date:  1983/05/23

    article content
    """
    And the layout view:
    """
    Layout
    = yield
    """
    And the article view:
    """
    Article
    = content
    """
    When I visit "/1983/05/23/simple-article"
    Then I should see:
    """
    Layout
    Article
    article content
    """
