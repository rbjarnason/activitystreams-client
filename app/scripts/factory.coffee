'use strict';

root = exports ? this
root.ActivitySnippet = ActivitySnippet ? {}

class ActivitySnippet.ActivityStreamSnippetFactory
    defaults =
      debug: false
      snippetClass: '.activitysnippet'

    constructor: (options) ->
      @settings = ActivitySnippet.utils.extend({}, options, defaults)
      throw new Error('SnippetFactory:: Must pass in ActivityStreamAPI') unless @settings.ActivityStreamAPI
      @count = 0
      @actor = @settings.actor ? null
      @templates = ActivitySnippet.ActivitySnippetTemplates # grab global snippet templates
      @snippets = @initActivityStreamSnippets(@settings, @templates)
      @active = @settings.active ? true

    initActivityStreamSnippets: (settings, templates, count) ->
      snippetNodelist = document.querySelectorAll settings.snippetClass
      snippets = []
      for i of snippetNodelist
          if snippetNodelist.hasOwnProperty(i) and i != 'length' and not snippetNodelist[i].getAttribute('data-id')?
              snippetNodelist[i].setAttribute('data-id', 'as' + @count)
              try
                snippets.push new ActivitySnippet.ActivityStreamSnippet(snippetNodelist[i], settings, templates)
              catch error
                console.log error.stack

              @count++
      snippets

    fetch: ->
        url = [@settings.ActivityStreamAPI, @actor.type, @actor.id,'activities'].join('/')
        ActivitySnippet.utils.getJSON url, ((data) ->
          data
        ), (error) ->
          error

    refresh: (actor) ->
        # We want the fetch to rerun only if there has been a change in the amount of snippets on the page
        # Therefore, we check to see if the count has changed and only then call fetch
        @actor = actor ? @actor
        c = @count
        @snippets.push.apply @snippets, @initActivityStreamSnippets(@settings, @templates)
        data = @fetch() unless @count == c or @count == 0

    toggleState: ->
        @active = !@active
        for i of @snippets
            @snippets[i].toggleState()
