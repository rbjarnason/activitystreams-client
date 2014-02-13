Feature 'See a snippet\n\t',

  ' As a user\n',
  '\t   I want to know that I can VERB an OBJECT\n',
  '\t   So that I can interact with it in my activity stream ', ->

    snippet = null

    Scenario 'On Load', ->
      isDocReady = 0
      timer = null

      Given 'A page', ->
        assert document != null, 'There is no DOM object'

      When 'That page loads', (done) ->
        assert ready != null, 'Can\'t find "ready"'
        ready ->
          isDocReady = 1
          done()

      Then 'I should have the ability to instantiate snippets on the page', ->
        snippet = new ActivityStreamSnippetFactory()
        assert snippet instanceof ActivityStreamSnippetFactory, 'Instance created was not of type ActivityStreamSnippet'

      And 'They should all be added to the collection of snippets', ->
        count = document.querySelectorAll('.activitysnippet').length;
        assert snippet.count == count, 'Amount of snippets on the page did not matched the collection length: ' + count + ' != ' + snippet.count

    Scenario 'Logged Out', ->
      Given 'I am an anonymous user', ->
        assert snippet.user == null, 'User is anonymous'

      When 'I go to a page that includes a snippet(s)', ->
        assert snippet.count > 0, 'There are snippets on the page'

      Then 'I should see the activity streams snippet', ->
        assert 1==1

      And 'I should see a count of VERBED', ->
        assert 1==1

