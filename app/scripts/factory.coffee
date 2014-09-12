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
        @templates = ActivitySnippet.ActivitySnippetTemplates # grab global snippet templates
        # Assume the service and everything is working to begin with.
        @disabled = false
        @active = false
        @activeCallbacks = []
        @inactiveCallbacks = []

        # unpack callbacks passed into Factory
        ActivitySnippet.utils.unpack(@activeCallbacks, options.activeCallbacks)
        ActivitySnippet.utils.unpack(@inactiveCallbacks, options.inactiveCallbacks)

        # Listen to events toggling the active state of the snippet.
        # This state is toggled if a valid actor is set or unset.
        @on "active", @toggleActive

        # Listen to events to toggle whether the snippet is disabled or not.
        @on "disabled", @toggleDisabled

        # Try to set an actor.
        @setActor @settings.actor

        # Initalize the snippets
        @snippets = @initActivityStreamSnippets(@settings, @templates, @activeCallbacks, @inactiveCallbacks)

    initActivityStreamSnippets: (settings, templates) ->
        snippetNodelist = document.querySelectorAll settings.snippetClass
        snippets = []
        for i of snippetNodelist
            if snippetNodelist.hasOwnProperty(i) and i != 'length' and not snippetNodelist[i].getAttribute('data-id')?
                snippetNodelist[i].setAttribute('data-id', 'as' + @count)
                try
                    snippets.push new ActivitySnippet.ActivityStreamSnippet(snippetNodelist[i], settings, templates, settings.activeCallbacks, settings.inactiveCallbacks, @)
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

    # Toggles whether the snippet has an active actor or not.
    toggleActive: (active) ->
        @active = if active? then active else !@active
        @trigger "render"

    # Toggles whether the snippet is disabled or not for some reason, e.g. the
    # service is down.
    toggleDisabled: (disabled) ->
        @disabled = if disabled? then disabled else !@disabled
        @trigger "render"

    setActor: (actor) ->
        if not @validActor(actor)
            actor = null
        @settings.actor = actor
        if @settings.actor? then @toggleActive(true) else @toggleActive(false)
        for i of @snippets
            @snippets[i].setActor @settings.actor

    validActor: (actor) ->
        if actor
            if actor.aid? and actor.api? and actor.type?
                return true
            else
                return false
