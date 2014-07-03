Feature 'Show Activites Count',
  'As a User',
  'When the page renders',
  'I want to see the counts of the activites', ->

    snippet = null

    beforeEach ->
      options =
        test: true

      snippet = new ActivityStreamSnippetFactory(options)

    afterEach ->
      snippet = null

    Scenario 'Logged Out', ->

      Given 'I am an anonymous user', ->
        assert snippet.user == null, 'User is anonymous'

      When 'I go to a page that includes a snippet(s)', ->
        assert snippet.count == 3, 'There are snippets on the page'

      Then 'I should see the activity streams snippets', ->
        assert 1==1

      And 'I should see a count of VERBED', ->
        snippet.collection[0].count.should.equal(4)
        snippet.collection[1].count.should.equal(2)
        snippet.collection[2].count.should.equal(3)
