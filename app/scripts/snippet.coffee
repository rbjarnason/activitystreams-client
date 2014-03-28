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
        @active = settings.active ? true
        @state = false
        @el = el
        @id = el.getAttribute('data-id')
        @activeCallbacks = activeCB
        @inactiveCallbacks = inactiveCB
        @factory = factory

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

    ################
    # Helper Methods
    ################

    constructUrls: ->
        #urls
        @urls =
            get:  "#{@service}/object/#{@object.type}/#{@object.aid}/#{@verb.type}"
            post: "#{@service}/activity"
        if @actor?
            @urls.delete = "#{@service}/activity/#{@actor.type}/#{@actor.aid}/#{@verb.type}/#{@object.type}/#{@object.aid}"

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
    toggleActive: ->
        @active = !@active
        @render()


    toggleState: (state) ->
        # Toggle activityState for items user has interacted with
        # Runs when snippet first loads and knows which items should be active
        # Toggles activityState flag on a particular snippet when clicked
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
            active: @active
            state: @state

        @el.innerHTML = @view(context)


    ###############
    # Event Binding
    ###############

    bindClick: =>
        @el.onclick = (event) =>
            if @active is true
                @fireCallbacks(@activeCallbacks)
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
                (error) ->
                    console.error error


    save: () =>
        # POST api/v1/activity
        unless @state
            ActivitySnippet.utils.POST @urls.post, @constructActivityObject(),
                (data) =>
                    @factory.trigger @namespace + ":update", count: @count+1, state: true
                ,
                (error) =>
                    console.error error
        else
            ActivitySnippet.utils.DELETE @urls.delete,
                (data) =>
                    @factory.trigger @namespace + ":update", count: @count-1, state: false
                ,
                (error) =>
                    console.error error
