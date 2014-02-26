Feature: Activity Snippet

@smoke
Scenario: AS-01: Test activity snippet page
    Given I am on the activity snippet home page
    Then I should see the "'Allo, 'Allo!" as title
    And I should see the "This is the playground for the Activity Stream Snippet!" as subtitle