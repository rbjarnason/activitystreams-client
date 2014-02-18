root = exports ? this

'use strict';

class root.ActivityStreamSnippetManager

    # init example for snippet: snippet.init({ ActivityStreamAPI: 'http://as.dev.nationalgeographic.com:9365/api/v1',
    #actor: { id: '1', type: 'mmdb_user', api: 'http...'}, user: { onLoggedIn: Function from header, onLoggedOut: Function from header } });
    
    # _M.User.loggedIn (userData) ->
    #   @user = createActor(userData.id)
    #     


    # defaults settings object
    defaults = 
      debug: false
      activityStreamAPI: 'http://as.dev.nationalgeographic.com:9365/api/v1'
      snippetClass: '.activitysnippet'


    constructDefaults = (options) ->
      if options?
        for own key, value of options
          defaults[key] = value
      defaults


    getTemplates = ->
      templates = window.ActivitySnippetTemplates # grab global snippet templates
      templates


    grabSnippetNodes = (options) -> 
        document.querySelectorAll options.snippetClass

    constructor: (options) ->

      @options = constructDefaults(options)
      @templates = getTemplates()
      @snippetNodelist = grabSnippetNodes(@options)
      @snippets = createActivityStreamSnippets(@snippetNodelist, @templates)
      @user = null

    createActivityStreamSnippets = (snippetNodelist, templates) ->
      snippets = []
      count = 0
      for i of snippetNodelist
          if snippetNodelist.hasOwnProperty(i) and i != 'length'
              snippetNodelist[i].setAttribute('data-id', 'as' + count)
              snippets.push new ActivityStreamSnippet(snippetNodelist[i], templates)
              count++
      snippets

    init: (options) ->
        data = fetch options

    fetch: (options) ->
        url = [@options.ActivityStreamAPI, options.actor.type, options.actor.id,'activities'].join('/')
        utils.getJSON url, ((data) ->
          data
        ), (error) ->
          error
