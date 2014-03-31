'use strict';

root = exports ? this
root.ActivitySnippet = ActivitySnippet ? {}

class ActivitySnippet.ActivityStreamSnippetFactory extends ActivitySnippet.Events
    defaults =
        debug: false
        snippetClass: '.activitysnippet'

    constructor: (options) ->
        @settings = ActivitySnippet.utils.extend({}, options, defaults)
        throw new Error('SnippetFactory:: Must pass in ActivityStreamAPI') unless @settings.ActivityStreamAPI
        @count = 0
        @actor = @settings.actor ? null
        @templates = ActivitySnippet.ActivitySnippetTemplates # grab global snippet templates
        @active = @settings.active ? true
        @activeCallbacks = []
        @inactiveCallbacks = []

        # unpack callbacks passed into Factory
        ActivitySnippet.utils.unpack(@activeCallbacks, options.activeCallbacks)
        ActivitySnippet.utils.unpack(@inactiveCallbacks, options.inactiveCallbacks)

        # Initalize the snippets
        @snippets = @initActivityStreamSnippets(@settings, @templates, @activeCallbacks, @inactiveCallbacks)

    initActivityStreamSnippets: (settings, templates, activeCallbacks, inactiveCallbacks, count) ->
        # Ensure actors are synced.
        if @validActor(settings.actor) then @setActor(settings.actor) else settings.actor = @actor

        snippetNodelist = document.querySelectorAll settings.snippetClass
        snippets = []
        for i of snippetNodelist
            if snippetNodelist.hasOwnProperty(i) and i != 'length' and not snippetNodelist[i].getAttribute('data-id')?
                snippetNodelist[i].setAttribute('data-id', 'as' + @count)
                try
                    snippets.push new ActivitySnippet.ActivityStreamSnippet(snippetNodelist[i], settings, templates, activeCallbacks, inactiveCallbacks, @)
                catch error
                    console.error error.stack

                @count++
        snippets

    fetch: =>
        for snippet in @snippets
            snippet.fetch()

    refresh: ->
        # We want the fetch to rerun only if there has been a change in the amount of snippets on the page
        # Therefore, we check to see if the count has changed and only then call fetch
        c = @count
        @snippets.push.apply @snippets, @initActivityStreamSnippets(@settings, @templates)

    toggleState: ->
        @active = !@active
        for i of @snippets
            @snippets[i].toggleActive()
        return

    setActor: (actor) ->
        if not @validActor(actor)
            actor = null
        @actor = actor
        for i of @snippets
            @snippets[i].setActor @actor

    validActor: (actor) ->
        if actor
            if actor.aid? and actor.api? and actor.type?
                return true
            else
                return false

    removeActor: ->
        @actor = null
        for i of @snippets
            @snippets[i].setActor @actor

