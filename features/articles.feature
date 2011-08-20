Feature: Article Page
  In order to display articles
  As a user
  I want to be able to view an article and it's relevant information

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
    %div.content= article.render
    %a{:href => article.path}
    """
    When I visit "/1983/05/23/simple-article"
    Then I should see:
    """
    <div class='title'>Simple Article</div>
    <div class='content'><p>article content</p></div>
    <a href='/1983/05/23/simple-article'></a>
    """
