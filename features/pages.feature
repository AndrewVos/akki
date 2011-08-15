Feature: Pages
  In order to display custom pages
  As a user
  I want to display custom pages

  Scenario: About page
    Given I have the page "about.haml":
    """
    %p This is the about page
    """
    And the layout template:
    """
    %html
      %body
        = yield
    """
    When I visit "about"
    Then I should see:
    """
    <html>
      <body>
        <p>This is the about page</p>
      </body>
    </html>

    """
