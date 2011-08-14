Feature: Article
  In order to display articles on
  As a user
  I want to be render blog pages

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
        = article.render
    """
    And I visit "1983/10/23/simple-article"
    Then I should see:
    """
    <html>
      <head>
        <title>Simple Article</title>
      </head>
      <body>
        <p>article content</p>
      </body>
    </html>

    """
