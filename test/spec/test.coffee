chai = require('chai')

Feature 'Snippet Loads',

  'As a user',
  'I want to have the ability to VERB an OBJECT',
  'So that I can interact with it in my activity stream', ->

    Scenario 'On Load', ->

      Given 'I am an anonymous user', ->
        chai.assert(1==1);

      When 'I go to homepage', ->
        chai.assert(1==1);

      Then 'I see big buttons', ->
        chai.assert(1==1);
