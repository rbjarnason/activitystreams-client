root = exports ? this

'use strict';

class root.ActivityStreamSnippetFactory

    constructor: ->
        snippets = document.querySelectorAll('.activitysnippet')
        @count = 0
        @collection = []
        @user = null
        @templates = window.ActivitySnippetTemplates # grab global snippet templates
        delete window.ActivitySnippetTemplates # remove them from the global scope
        for i of snippets
            if snippets.hasOwnProperty(i) and i != 'length'
                snippets[i].setAttribute('data-id', 'as' + @count)
                @collection.push new ActivityStreamSnippet(snippets[i], @templates)
                @count++

    init: (options) ->
        data = fetch options

    fetch= (options) ->
        url = [options.ActivityStreamAPI, options.actor.type, options.actor.id,'activities'].join('/')
        utils.getJSON url, ((data) ->
          data
        ), (error) ->
          error
