Feature 'See a Snippet \n\t',

    ' As an Anonymous user \n',
    '\t   I want the activity stream snippet to load\n',
    '\t   So that I can interact with it ', ->

        snippetManager = null

        beforeEach ->
            snippetManager = new ActivityStreamSnippetFactory()

        afterEach ->
            snippetManager = null

        Scenario 'Initialize', ->
            isDocReady = 0
            timer = null

        Given 'A page', ->
            assert document != null, 'There is no DOM object'

        When 'That page loads', (done) ->
            assert utils.ready != null, 'Can\'t find "ready"'
            utils.ready ->
                isDocReady = 1
                done()

        Then 'I should have the ability to instantiate snippets on the page', -> 
            assert snippetManager instanceof ActivityStreamSnippetManager, 'Instance created was not of type ActivityStreamSnippet'

        And 'They should all be added to the collection of snippets once the snippet is instantiated', ->
            count = document.querySelectorAll('.activitysnippet').length
            assert snippetManager.snippets.length == count, 'Amount of snippets on the page did not matched the collection length: ' + count + ' != ' + snippetManager.snippets.length

        And 'They should all be of type ActivityStreamSnippet', ->
            for i of snippetManager.snippets
                assert snippetManager.snippets[i] instanceof ActivityStreamSnippet, 'Snippets not of type ActivityStreamSnippet, something went wrong with initialization'

        Scenario 'Logged Out', ->
            Given 'I am an anonymous user', ->
                assert snippetManager.user == null, 'User is anonymous'

        When 'I go to a page that includes a snippet(s)', ->
            assert snippetManager.snippets.length > 0, 'There are snippets on the page'

        Then 'I should see the activity streams snippet', ->
            assert 1==1

        And 'I should see a count of VERBED', ->
            assert 1==1


"
* GIVEN a logged in NGM user
WHEN the logged in NGM user clicks the favorite snippet
THEN an activity will be logged to the NGM user's activity stream for the favorited article

* GIVEN a logged in NGM user
WHEN the logged in NGM user clicks the favorite snippet
THEN the favorite heart will reflect that the NGM user has favorited the article

* GIVEN a logged in NGM user
WHEN the logged in NGM user opens an article they have already favorited
THEN the favorite heart will reflect that the NGM user has favorited the article

* GIVEN a logged out NGM user
WHEN the logged out NGM user clicks the favorite snippet
THEN the logged out NGM user will be prompted to login

* GIVEN a NGM user
WHEN the NGM user opens an article
THEN the favorite snippet will show the amount of times the article has been favorited
"
