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
        @fetchActivityForUser() if @actor

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
            get:  "#{@service}/object/#{@object.type}/#{@object.aid}/#{@verb.type}?limit=0"
        if @actor?
            @urls.post = "#{@service}/activity"
            @urls.delete = "#{@service}/activity/#{@actor.type}/#{@actor.aid}/#{@verb.type}/#{@object.type}/#{@object.aid}"
            @urls.getActivityForUser = "#{@service}/actor/#{@actor.type}/#{@actor.aid}/#{@verb.type}/#{@object.type}/#{@object.aid}/"
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


    formatNumber: (number, decPlaces, enableSpecialCharacters) ->
        abbrev = undefined
        i = undefined
        size = undefined
        specialCaracter = undefined
        decPlaces = Math.pow(10, parseInt(decPlaces))
        return false  if isNaN(Number(number))
        @drEvil = false
        abbrev = [
            "k"
            "m"
            "b"
            "t"
        ]
        specialCaracter =
            314: "π"
            2718: "e"
            1000000: "One Milllllllllion"

        size = 0
        if enableSpecialCharacters and specialCaracter[number]
            @drEvil = true  if number is 1000000
            number = specialCaracter[number]
        else
            i = abbrev.length - 1
            while i >= 0
                size = Math.pow(10, (i + 1) * 3)
                if size <= number
                    number = Math.floor(number * decPlaces / size) / decPlaces
                    number += abbrev[i]
                    break
                i--
        number

    ############
    # View Logic
    ############

    render: ->
        context =
            activity: @activity
            count: @formatNumber(@count, 1, true)
            evil: @drEvil
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
                    @save()
                else
                    # Only fire the inactive callbacks if the server is up and
                    # the fetch succeeded.
                    @fetch success: () => @fireCallbacks @inactiveCallbacks
                    @fetchActivityForUser

    ##############
    #Service Calls
    ##############
    fetch: (options = {}) ->
        ActivitySnippet.utils.GET @urls.get,
            (data) =>
                @parse data
                @factory.trigger @namespace + ":update", count: @count, state: @state
                if options.success then options.success data
            ,
            (error) =>
                # The service is down, so disable the snippet.
                @factory.trigger "disabled", true
                @factory.trigger @namespace + ":update", count: @count, state: @state
                if options.error then options.error error

    fetchActivityForUser: (options = {}) ->
            ActivitySnippet.utils.GET @urls.getActivityForUser,
                (data) =>
                    if data? and data.length > 0
                        @toggleState true
                    else
                        @toggleState false
                    @factory.trigger @namespace + ":update", count: @count, state: @state
                    if options.success then options.success data
                ,
                (error) =>
                    # Couldn't fetch the user activities.
                    @factory.trigger "disabled", false
                    console.log @factory.disabled
                    @factory.trigger @namespace + ":update", count: @count, state: @state
                    if options.error then options.error error

    save: (options = {}) =>
        if not @pending
            @pending = true
            # POST api/v1/activity
            unless @state
                ActivitySnippet.utils.POST @urls.post, @constructActivityObject(),
                    (data) =>
                        # If the state is already true, then the user already
                        # liked the object, so don't increase the count.
                        @factory.trigger @namespace + ":update", count: @count+!@state, state: true
                        @pending = false
                        if options.success then options.success data
                    ,
                    (error) =>
                        # The service is down, so disable the snippet.
                        @factory.trigger "disabled", true
                        console.error error
                        @pending = false
                        if options.error then options.error error
            else
                ActivitySnippet.utils.DELETE @urls.delete,
                    (data) =>
                        # If the sate is already false, then the user already
                        # un-liked the object, so don't decrease the count.
                        @factory.trigger @namespace + ":update", count: @count-@state, state: false
                        @pending = false
                        if options.success then options.success data
                    ,
                    (error) =>
                        # The service is down, so disable the snippet.
                        @factory.trigger "disabled", true
                        console.error error
                        @pending = false
                        if options.error then options.error error
