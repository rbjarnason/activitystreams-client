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

        @activityState = false

        # Init View
        @view = templates['app/scripts/templates/' + @verb + '.handlebars']
        @render()

    save: (activity, processSuccess, processError) ->
        # POST api/v1/activity
        # {acotr: {id:1, type: mmdb_user, api: someurl.com}, {verb: {verb:FAVORITED}, object{id:1, type:ngm_article, api: someurl}}
        #
        url = [@service, 'activity'].join('/')

        ActivitySnippet.postJSON url, activity,
            (data) =>
                processSuccess data
            ,
            (error) =>
                processError data
          

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
        @object.counts = 0
        @render()

    fetch: ->
        # Only Called when there is no Actor present
        url = [@service, @object.type, @object.id, @verb.toUpperCase()].join('/')
        ActivitySnippet.utils.getJSON url, 
                (data) =>
                    @init data
                ,
                (error) ->
                    console.log error
