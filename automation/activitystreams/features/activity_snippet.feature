Feature: Activity Snippet

@smoke
Scenario: AS-01: Test activity snippet page
    Given I am on the activity snippet home page
    Then I should see the "'Allo, 'Allo!" as title
    And I should see the "This is the playground for the Activity Stream Snippet!" as subtitle
    And I should see the user logged in
    And I should see the "First" eye as unwatched
    And I should see the "Second" eye as unwatched
    And I should see the "First" heart as unliked
    And I should see the "Second" heart as unliked
    When I click on the "First" eye
    Then I should see the "First" eye as watched
    When I click on the "First" heart
    Then I should see the "First" heart as liked
        