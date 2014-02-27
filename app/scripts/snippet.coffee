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
        @activityState = false
        @el = el
        @id = el.getAttribute('data-id')

        # Activity
        @actor = actor ? null
        @verb = el.getAttribute('data-verb')
        @object = @constructObject(el)
        @count = 0

        # Init View
        @view = templates['app/scripts/templates/' + @verb + '.handlebars']
        @render()


    constructObject: (el) ->
        id =  el.getAttribute('data-object-id')
        type = el.getAttribute('data-object-type')
        obj = 
            type: type
            api: el.getAttribute('data-object-api')
        obj[type + '_id'] = id
        obj

    constructActivity: (actor, verb, object) ->
        activity =
            actor: actor
            verb:
                type: verb.toUpperCase()
            object: object

        activity

    bindClick: () =>
        @el.onclick = (event) =>
            @toggleActivityState()
            @save(@activity)


    save: (activity) =>
        # POST api/v1/activity
        # {acotr: {id:1, type: mmdb_user, api: someurl.com}, {verb: {verb:FAVORITED}, object{id:1, type:ngm_article, api: someurl}}
        
        url = [@service, 'activity'].join('/')

        ActivitySnippet.utils.postJSON url, activity,
            (data) =>
                console.log data 
            ,
            (error) =>
                console.log error 
          

    toggleActive: ->
        @active = !@active
        @render()


    toggleActivityState: ->
        console.log @activityState
        @activityState = !@activityState
        @render()

    render: ->

        @activity =
            actor: @actor
            verb: @verb
            object: @object
        context =
            activity: @activity
            active: @active

        if @activityState
            context.activityState 'activitysocial-icon-active'

        @el.innerHTML = @view(context)

    setActor: (actor) ->
        unless @actor == actor
            @actor = actor ? @actor
            @activity = @constructActivity @actor, @verb, @object
            @bindClick()


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
