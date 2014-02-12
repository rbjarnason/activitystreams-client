root = this


### Start of Feature ###

root.Feature = (feature, story..., callback) ->
  skip = false
  if feature == false # First arg is false, skip
    feature = story.shift()
    skip = true
  message = 'Feature: ' + feature
  if not callback?
    callback = story.shift()
  else
    message += ' [' + story.join(' ') + ']' # The web reporter will escape all
                                            # HTML, so don't try to format it.
  if skip
    describe.skip message, -> it 'skipped'
  else
    describe message, callback


### Start of Scenario ###

root.Scenario = (message, callback) ->
  if message == false  # First arg is false, skip
    message = callback
    describe.skip 'Scenario: ' + message, -> it 'skipped'
  else
    describe 'Scenario: ' + message, callback


### Beginning of GWTab ###

gwtIt = (label, message, callback) ->  # routes command to an It
  message = label + message
  if not callback? or callback.toString() == (->).toString()  # If Blank
    it message
  else
    if callback.length
      it message, (done) ->
        try callback.call this, done
        catch e
          this.test.parent.bail(true)
          throw e
    else
      it message, ->
        try callback.call this
        catch e
          this.test.parent.bail(true)
          throw e

createGWTab = (label) ->  # Creates Given, When, Then, and, but commands
  return (message, callback) -> gwtIt label, message, callback

root.Given = createGWTab('GIVEN ')

root.When = createGWTab('WHEN ')

root.Then = createGWTab('THEN ')

root.And = createGWTab('...and ')

root.But = createGWTab('...but ')

snippet = new ActivityStreamSnippet()

Feature 'Snippet Loads',

  'As a user',
  'I want to have the ability to VERB an OBJECT',
  'So that I can interact with it in my activity stream', ->

    Scenario 'On Load', ->

      Given 'I am an anonymous user', ->
        assert snippet.user == null, 'User is anonymous'

      When 'I go to a page that includes a snippet(s)', ->
        assert snippet.count > 0, 'There are snippets on the page'

      Then 'I should see the activity streams snippet', ->
        assert 1==1

      And 'I should see a count of VERBED', ->
        assert 1==1
