root = exports ? this

'use strict';

class root.ActivityStreamSnippetFactory

    # init example for snippet: snippet.init({ ActivityStreamAPI: 'http://as.dev.nationalgeographic.com:9365/api/v1',
    #actor: { id: '1', type: 'mmdb_user', api: 'http...'}, user: { onLoggedIn: Function from header, onLoggedOut: Function from header } });

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

    constructor: (options) ->

      @options = constructDefaults(options)
      @templates = getTemplates()
      @snippets = grabSnippets(@options)
      @count = 0
      @collection = createActivityStreamSnippets(@snippets, @templates)
      @user = null

    grabSnippets = (options) -> 
        document.querySelectorAll options.snippetClass

    createActivityStreamSnippets = (snippets, templates) ->
      collection = []
      for i of snippets
          if snippets.hasOwnProperty(i) and i != 'length'
              snippets[i].setAttribute('data-id', 'as' + @count)
              collection.push(new ActivityStreamSnippet snippets[i], templates)
              @count++
      collection

    init: (options) ->
        data = fetch options

    fetch: (options) ->
        url = [@options.ActivityStreamAPI, options.actor.type, options.actor.id,'activities'].join('/')
        utils.getJSON url, ((data) ->
          data
        ), (error) ->
          error
