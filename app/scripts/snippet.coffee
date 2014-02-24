'use strict';

root = exports ? this
root.ActivitySnippet = ActivitySnippet ? {}

class ActivitySnippet.ActivityStreamSnippet
    constructor: (el, settings, templates, actor) ->
        # Base setup
        @service = settings.ActivityStreamAPI
        @active = settings.active ? true
        @el = el
        @id = el.getAttribute('data-id')

        # Activity
        @actor = actor ? null
        @verb = el.getAttribute('data-verb')
        @object =
            id: el.getAttribute('data-object-id')
            type: el.getAttribute('data-object-type')
            api: el.getAttribute('data-object-api')
        @count = 0

        # Init View
        @view = templates['app/scripts/templates/' + @verb + '.handlebars']
        @render()

    save: ->
        url = [@service, @object.type, @object.id, @verb].join('/')
        ActivitySnippet.utils.getJSON url, (data) ->
          return data
        , (error) ->
          return error

    toggleState: ->
        @active = !@active
        @render()

    render: ->
        @activity =
            actor: @actor
            verb: @verb
            object: @object
        context =
            activity: @activity
            active: @active
        @el.innerHTML = @view(context)

    setActor: (actor) ->
        unless @actor == actor
            @actor = actor ? @actor