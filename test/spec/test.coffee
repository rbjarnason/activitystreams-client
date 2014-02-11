Feature 'Snippet Loads',

  'As a user',
  'I want to have the ability to VERB an OBJECT',
  'So that I can interact with it in my activity stream', ->

    Scenario 'On Load', ->

      Given 'I am an anonymous user', ->
        assert snippet.user == null, 'User is anonymous'

      When 'I go to a page that includes a snippet(s)', ->
        assert snippet.collection.length > 0, 'There are snippets on the page'

      Then 'I should see the activity streams snippet', ->
        assert 1==1

      And 'I should see a count of VERBED', ->
        assert 1==1
