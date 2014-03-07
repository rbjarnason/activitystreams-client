Feature: Activity Snippet

@smoke
Scenario: AS-01: Test activity snippet page titles
    Given I am on the activity snippet home page
    Then I should see the "'Allo, 'Allo!" as title
    And I should see the "This is the playground for the Activity Stream Snippet!" as subtitle
    
@smoke
Scenario: AS-02: Test user logged in activity snippet
    Given I am on the activity snippet home page
    Then I should see the message "Welcome, Anonymous User"

@smoke
Scenario: AS-03: Test user logged in activity snippet
    Given I am on the activity snippet home page
    Then I should see the "First" eye as unwatched
    And I should see the "Second" eye as unwatched
    And I should see the "First" heart as unliked
    And I should see the "Second" heart as unliked
    When I click on the "First" eye
    Then I should see the "First" eye as watched
    When I click on the "Second" eye
    Then I should see the "Second" eye as watched
    When I click on the "First" heart
    Then I should see the "First" heart as liked
    When I click on the "Second" heart
    Then I should see the "Second" heart as liked
        