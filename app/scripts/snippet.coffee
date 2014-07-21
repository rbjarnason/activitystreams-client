'use strict';

root = exports ? this
root.ActivitySnippet = ActivitySnippet ? {}

class ActivitySnippet.ActivityStreamSnippet extends ActivitySnippet.Events

    constructor: (el, settings, templates, activeCB, inactiveCB, factory) ->

        #Basic Exception Handling
        unless el?
            throw new Error('Need Html Element')

        unless templates?
            throw new Error('Need Templates Object')

        unless settings.ActivityStreamAPI?
            throw new Error('Need ActivityStreamAPI endpoint')

        # Base setup
        @service = settings.ActivityStreamAPI
        @state = false
        @el = el
        @id = el.getAttribute('data-id')
        @activeCallbacks = activeCB
        @inactiveCallbacks = inactiveCB
        @factory = factory
        @pending = false

        # Activity
        @actor = settings.actor ? null
        @verb =
            type: el.getAttribute('data-verb').toUpperCase()
        @object =
            aid: el.getAttribute('data-object-aid')
            type: el.getAttribute('data-object-type')
            api: el.getAttribute('data-object-api')
        @count = 0

        # Init
        @view = templates['app/scripts/templates/' + @verb.type + '.handlebars']
        @constructActivityObject()
        @constructUrls()
        @fetch()

        # Listen to events.
        @namespace = @verb + @object.type + @object.aid
        @listenTo factory, @namespace + ":update", @update
        @listenTo factory, "render", @render

    ################
    # Helper Methods
    ################

    constructUrls: ->
        #urls
        @urls =
            get:  "#{@service}/object/#{@object.type}/#{@object.aid}/#{@verb.type}"
        if @actor?
            @urls.post = "#{@service}/activity"
            @urls.delete = "#{@service}/activity/#{@actor.type}/#{@actor.aid}/#{@verb.type}/#{@object.type}/#{@object.aid}"
        else
            delete @urls.delete

    constructActivityObject: ->
        @activity =
            actor: @actor
            verb: @verb
            object: @object

    fireCallbacks: (cb) =>
        for i of cb
            cb[i].call @

    parse: (data) ->
        if data? and data[0]?
            @count = data[0].totalItems if typeof data[0].totalItems is "number"
            for own index of data[0].items
                if @actor? then @matchActor(data[0].items[index])

    matchActor: (activity) ->
        if activity?
            actor = activity.actor.data
            if actor.aid is String(@actor.aid) and actor.api is String(@actor.api)
                @toggleState true

    ##################
    # State Management
    ##################
    toggleState: (state) ->
        # Activity state -- True/False
        # Stores the state of the activity based on whether the actor has done it or not
        @state = if state? then state else !@state

    setActor: (actor) ->
        @actor = actor
        @constructUrls()

    ################
    # Update Snippet
    ################

    update: (data) ->
        @toggleState data.state
        @count = data.count
        @render()
        @bindClick()

    ############
    # View Logic
    ############

    render: ->
        context =
            activity: @activity
            count: @count
            active: @factory.active
            disabled: @factory.disabled
            state: @state

        @el.innerHTML = @view(context)


    ###############
    # Event Binding
    ###############

    bindClick: =>
        @el.onclick = (event) =>
            if not @factory.disabled
                if @factory.active is true
                    @fireCallbacks(@activeCallbacks)
                    if not @pending
                        @pending = true
                        @save()
                else
                    @fireCallbacks(@inactiveCallbacks)

    ##############
    #Service Calls
    ##############
    fetch: ->
        ActivitySnippet.utils.GET @urls.get,
                (data) =>
                    @parse data
                    @factory.trigger @namespace + ":update", count: @count, state: @state
                ,
                (error) =>
                    # The service is down, so disable the snippet.
                    @factory.trigger "disabled", true
                    @factory.trigger @namespace + ":update", count: @count, state: @state


    save: () =>
        # POST api/v1/activity
        unless @state
            ActivitySnippet.utils.POST @urls.post, @constructActivityObject(),
                (data) =>
                    # If the state is already true, then the user already
                    # liked the object, so don't increase the count.
                    @factory.trigger @namespace + ":update", count: @count+!@state, state: true
                    @pending = false
                ,
                (error) =>
                    # The service is down, so disable the snippet.
                    @factory.trigger "disabled", true
                    console.error error
                    @pending = false
        else
            ActivitySnippet.utils.DELETE @urls.delete,
                (data) =>
                    # If the sate is already false, then the user already
                    # un-liked the object, so don't decrease the count.
                    @factory.trigger @namespace + ":update", count: @count-@state, state: false
                    @pending = false
                ,
                (error) =>
                    # The service is down, so disable the snippet.
                    @factory.trigger "disabled", true
                    console.error error
                    @pending = false
