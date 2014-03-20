Feature: Activity Snippet

 
Scenario: AS-04: Test activity snippet page titles and elements
    Given I am on the activity snippet home page
    Then I should see the "'Allo, 'Allo!" as title
    And I should see the message "Welcome, Anonymous User"
    And I should see "taggled user state" button
    And I should see the "This is the playground for the Activity Stream Snippet!" as subtitle
    And I should see the "Snippet event list" 
    And I should see the "Page loaded" message at the bottom of Snippet event List


Scenario: AS-05: Test user Anonymous activity snippet
    Given I am on the activity snippet home page
    Then I should see the message "Welcome, Anonymous User"
    And I should see the "First" eye as unwatched
    When I click on the "First" eye
    Then I should see the "First" eye as unwatched
    And I should see the "Inactive Test Callback Fired" message at the bottom of Snippet event List
    And I should see the "Second" eye as unwatched
    When I click on the "Second" eye
    Then I should see the "Second" eye as unwatched
    And I should see the "Inactive Test Callback Fired" message at the bottom of Snippet event List
    And I should see the "First" heart as unliked
    When I click on the "First" heart
    Then I should see the "First" heart as unliked
    And I should see the "Inactive Test Callback Fired" message at the bottom of Snippet event List
    And I should see the "Second" heart as unliked
    When I click on the "Second" heart
    Then I should see the "Second" heart as unliked
    And I should see the "Inactive Test Callback Fired" message at the bottom of Snippet event List


Scenario: AS-06: Test user Active 
    Given I am on the activity snippet home page
    Then I should see the message "Welcome, Anonymous User"
    And I should see the "Page loaded" message at the bottom of Snippet event List
    When I click on the "Taggle user state" button
    Then I should see the message "Welcome, Active User!"
    And I should see the "Active State changed to true" message at the bottom of Snippet event List
    And I should see the "First" eye as unwatched
    When I click on the "First" eye
    Then I should see the "First" eye as watched
    And I should see the "Active Test Callback Fired" message at the bottom of Snippet event List
    And I should see the "Second" eye as unwatched
    When I click on the "Second" eye
    Then I should see the "Second" eye as watched
    And I should see the "Active Test Callback Fired" message at the bottom of Snippet event List
    And I should see the "First" heart as unliked
    When I click on the "First" heart
    Then I should see the "First" heart as liked
    And I should see the "Active Test Callback Fired" message at the bottom of Snippet event List
    And I should see the "Second" heart as unliked
    When I click on the "Second" heart
    Then I should see the "Second" heart as liked
    And I should see the "Active Test Callback Fired" message at the bottom of Snippet event List
    When I click on the "Taggle user state" button
    Then I should see the "Active State changed to false" message at the bottom of Snippet event List


Scenario: AS-07: Test user Login 
    Given I am on the activity snippet home page
    Then I should see the message "Welcome, Anonymous User"
    And I should see the "Page loaded" message at the bottom of Snippet event List
    When I click on the "Taggle user state" button
    Then I should see the message "Welcome, Active User!"
    And I should see the "Active State changed to true" message at the bottom of Snippet event List
    When I click on the "Taggle user state" button
    Then I should see the "Active State changed to false" message at the bottom of Snippet event List
    And I should see the message "Welcome, Anonymous User!"

Scenario: AS-08
	Given I am on the activity snippet home page
	When the user accesses an object with a snippet
	Then the snippet will show a current count of times the object has had the verb chosen for it

Scenario: AS-09
	Given I am on the activity snippet home page
	When the logged in user verbs an object
	Then the snippet count will be incremented by 1

Scenario: AS-10
	Given I am on the activity snippet home page
	When the logged in user verbs an object
	And the logged in user has already verbed the object
	Then the snippet count will be decremented by 1

Scenario: AS-11
	Given I am on the activity snippet home page
	When the user first opens a page with an object with a snippet
	And the activity streams service is down
	Then the snippet should be greyed out
	And you should not be able to interact with the snippet
