'use strict';

root = exports ? this
root.ActivitySnippet = ActivitySnippet ? {}

class ActivitySnippet.ActivityStreamSnippet

    constructor: (el, settings, templates, actor) ->

        #Basic Exception Handling
        unless el?
            throw new Error('Need Html Element')

        unless templates?
            throw new Error('Need Templates Object')

        unless settings.ActivityStreamAPI?
            throw new Error('Need ActivityStreamAPI endpoint')

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
        utils.getJSON url, (data) ->
          return data
        , (error) ->
          return error

    toggleActive: ->
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

    init:  (data) =>
        @eeeeeeeee = 'hello there'
        @object.counts = 0
        @render()

    fetch: (processSuccess, processError) ->
        # Only Called when there is no Actor present
        url = [@service, @object.type, @object.id, @verb.toUpperCase()].join('/')

        ActivitySnippet.utils.getJSON url, 
                (data) =>
                    processSuccess data
                (error) ->
                    processError error
