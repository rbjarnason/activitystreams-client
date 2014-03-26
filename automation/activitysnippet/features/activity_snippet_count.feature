Feature: Activity Snippet Count

Scenario: AS-08
    Given I am on the activity snippet test page
    Then I should see the current count of time that the verbs has been chosen


Scenario: AS-09
    Given I am on the activity snippet test page
    When I loged in an object never verbed
    And I verb the object
    Then I should see the snippet count incremented by 1


Scenario: AS-10
    Given I am on the activity snippet test page 
    When I loged in an object already verbed
    And I verb the object
    Then I should see the snippet count decremented by 1


Scenario: AS-11
    Given I am on the activity snippet test page  
    Then I should see the snippet greyed out
    And I should not be able to interact with the snippet
