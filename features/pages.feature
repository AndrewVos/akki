Feature: Pages
  In order to display custom pages
  As a user
  I want to display custom pages

  Scenario: About page
    Given I have the page "example-page"
    When I visit "example-page"
    Then I should see:
    """
    <p>This is the example page</p>
    """
