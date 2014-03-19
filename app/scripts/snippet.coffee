'use strict';

root = exports ? this
root.ActivitySnippet = ActivitySnippet ? {}

class ActivitySnippet.ActivityStreamSnippet

    constructor: (el, settings, templates, activeCB, inactiveCB) ->

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
        if data?
            for obj in data
                @count = obj.totalItems unless typeof obj.totalItems == 'object'
                for own index of obj.items
                    if @actor? then @matchActor(obj.items[index])

    matchActor: (activity) ->
        if activity?
            actor = activity.actor.data
            if actor.aid is String(@actor.aid) and actor.api is String(@actor.api)
                @toggleState()

    ##################
    # State Management
    ##################
    toggleActive: ->
        @active = !@active
        @render()


    toggleState: ->
        # Toggle activityState for items user has interacted with
        # Runs when snippet first loads and knows which items should be active
        # Toggles activityState flag on a particular snippet when clicked
        @state = !@state

    setActor: (actor) ->
        @actor = actor
        @constructUrls()

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
        # Only called when there is no Actor present
        ActivitySnippet.utils.GET @urls.get, 
                (data) =>
                    @render(@parse(data))
                    @bindClick()
                ,
                (error) ->
                    console.error error


    save: () =>
        # POST api/v1/activity
        unless @state
            ActivitySnippet.utils.POST @urls.post, @constructActivityObject(),
                (data) =>
                    @toggleState()
                    @count++
                    @render()
                ,
                (error) =>
                    console.error error
        else
            ActivitySnippet.utils.DELETE @urls.delete,
                (data) =>
                    @toggleState()
                    @count--
                    @render()
                ,
                (error) =>
                    console.error error
