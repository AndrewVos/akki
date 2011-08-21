Feature: Home Page
  In order to display a main page
  As a blogger
  I want to be able to render a home page view

  Scenario: Simple home page
    Given I have the view "index.haml" with the contents
    """
    Welcome to my blog
    """
    When I visit "/"
    Then I should see:
    """
    Welcome to my blog
    """
