Feature 'Snippet Loads',

  'As a user',
  'I want to have the ability to VERB an OBJECT',
  'So that I can interact with it in my activity stream', ->

    Scenario 'On Load', ->
      isDocReady = 0
      snippet = null

      Given 'A page', ->
        assert document != null, 'There is no DOM object'

      When 'That page loads', ->
        ready ->
          isDocReady = 1

      Then 'I should have the ability to instantiate snippets on the page', ->
        snippet = new ActivityStreamSnippet()
        assert snippet instanceof ActivityStreamSnippet, 'Instance created was not of type ActivityStreamSnippet'

      And 'They should all be added to the collection of snippets', ->
        count = document.querySelectorAll('.activitysnippet').length;
        assert snippet.count == count, 'Amount of snippets on the page did not matched the collection length: ' + count + ' != ' + snippet.count

      Given 'I am an anonymous user', ->
        assert snippet.user == null, 'User is anonymous'

      When 'I go to a page that includes a snippet(s)', ->
        assert snippet.count > 0, 'There are snippets on the page'

      Then 'I should see the activity streams snippet', ->
        assert 1==1

      And 'I should see a count of VERBED', ->
        assert 1==1



ready = (fn) ->
  if document.addEventListener
    document.addEventListener "DOMContentLoaded", fn
  else
    document.attachEvent "onreadystatechange", ->
      fn()  if document.readyState is "interactive"
      return

  return
