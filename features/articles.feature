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
    And the layout template:
    """
    %html
      %head
        %title= article.title
      %body
        = yield
    """
    And the article template:
    """
    %div.article= article.render
    """
    When I visit "1983/10/23/simple-article"
    Then I should see:
    """
    <html>
      <head>
        <title>Simple Article</title>
      </head>
      <body>
        <div class='article'><p>article content</p></div>
      </body>
    </html>

    """
