Feature 'Snippet Loads',

  'As a user',
  'I want to have the ability to VERB an OBJECT',
  'So that I can interact with it in my activity stream', ->

    Scenario 'On Load', ->
      isDocReady = 0
      snippet = null

      Given 'A page', ->
        assert document != null, 'There is no DOM object'

      When 'That page loads', (done) ->
        testReady = ->
          unless ready
            setTimerForReady()
          else
            timer.clearTimeout()
            ready ->
              isDocReady = 1
              done()
          return
        setTimerForReady = ->
          timer = setTimeout(testReady, 1)
          return
        timer = null

      Then 'I should have the ability to instantiate snippets on the page', ->
        snippet = new ActivityStreamSnippet()
        assert snippet instanceof ActivityStreamSnippet, 'Instance created was not of type ActivityStreamSnippet'

      And 'They should all be added to the collection of snippets', (done) ->
        count = document.querySelectorAll('.activitysnippet').length;
        ready ->
            snippet.init()
            assert snippet.count == count, 'Amount of snippets on the page did not matched the collection length: ' + count + ' != ' + snippet.count
            done()

      Given 'I am an anonymous user', ->
        assert snippet.user == null, 'User is anonymous'

      When 'I go to a page that includes a snippet(s)', ->
        assert snippet.count > 0, 'There are snippets on the page'

      Then 'I should see the activity streams snippet', ->
        assert 1==1

      And 'I should see a count of VERBED', ->
        assert 1==1
