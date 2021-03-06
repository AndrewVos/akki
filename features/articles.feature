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
    And I have the page "article.haml" with the contents
    """
    %div.title= context.article.title
    %div.content= render_article(context.article)
    %a{:href => context.article.path}
    """
    When I visit "/1983/05/23/simple-article"
    Then I should see:
    """
    <div class='title'>Simple Article</div>
    <div class='content'><p>article content</p></div>
    <a href='/1983/05/23/simple-article'></a>
    """

  Scenario: Article referencing settings object
    Given I have the article file "1983-05-23-simple-article.txt"
    """
    title: Simple Article
    date:  1983/05/23

    = settings.title
    = context.article.title
    """
    And the application setting "title" with the value "The Blog Title"
    And I have the page "article.haml" with the contents
    """
    = render_article(context.article)
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
    And I have the view "layout.haml" with the contents
    """
    Layout
    = yield
    """
    And I have the page "article.haml" with the contents
    """
    Article
    = render_article(context.article)
    """
    When I visit "/1983/05/23/simple-article"
    Then I should see:
    """
    Layout
    Article
    article content
    """
