'use strict';

root = exports ? this
root.ActivitySnippet = ActivitySnippet ? {}

class ActivitySnippet.ActivityStreamSnippetFactory
    settings = null
    defaults =
      debug: false
      snippetClass: '.activitysnippet'
    count = 0

    constructor: (options) ->
      settings = ActivitySnippet.utils.extend({}, options, defaults)
      @templates = window.ActivitySnippetTemplates # grab global snippet templates
      @snippets = initActivityStreamSnippets(settings.snippetClass, @templates)
      @user = null

    # init example for snippet: snippet.init({ ActivityStreamAPI: 'http://as.dev.nationalgeographic.com:9365/api/v1',
    #actor: { id: '1', type: 'mmdb_user', api: 'http...'}, user: { onLoggedIn: Function from header, onLoggedOut: Function from header } });
    init: ->
        @snippets.push.apply @snippets, initActivityStreamSnippets(settings.snippetClass, @templates)
        data = @fetch

    # _M.User.loggedIn (userData) ->
    #   @user = createActor(userData.id)
    #

    initActivityStreamSnippets = (snippetClass, templates) ->
      snippetNodelist = document.querySelectorAll snippetClass
      snippets = []
      for i of snippetNodelist
          if snippetNodelist.hasOwnProperty(i) and i != 'length' and not snippetNodelist[i].getAttribute('data-id')?
              snippetNodelist[i].setAttribute('data-id', 'as' + count)
              try
                snippets.push new ActivityStreamSnippet(snippetNodelist[i], templates)
              catch error
                console.log error

              count++
      console.log snippets, 'here'
      snippets

    fetch: ->
        url = [settings.ActivityStreamAPI, settings.actor.type, settings.actor.id,'activities'].join('/')
        utils.getJSON url, ((data) ->
          data
        ), (error) ->
          error
