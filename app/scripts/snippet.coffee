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
        @verb = el.getAttribute('data-verb').toUpperCase()
        @object = 
            id: el.getAttribute('data-object-id')
            type: el.getAttribute('data-object-type')
            api: el.getAttribute('data-object-api')

        @count = 0

        #urls
        @urls = @createUrls()

        # Init View
        @view = templates['app/scripts/templates/' + @verb + '.handlebars']
        @fetch()
        @bindClick()


    ################
    # Helper Methods
    ################

    createUrls: ->
        urls = {}
        urls.get = "#{@service}/object/#{@object.type}/#{@object.id}/#{@verb}"
        if @actor?
            # urls.get = "#{@service}/activity/#{@actor.type}/#{@actor.id}/#{@verb}/#{@object.type}/#{@object.id}"
            urls.post = "#{@service}/activity"
            urls.del =  "#{@service}/activity/#{@actor.type}/#{@actor.id}/#{@verb}/#{@object.type}/#{@object.id}"
        urls

    map: (obj) ->
        newObj = ActivitySnippet.utils.extend({}, obj)
        newObj[newObj.type + '_id'] = newObj.id
        newObj[newObj.type + '_api'] = newObj.api
        delete newObj['id']
        delete newObj['api']
        newObj


    constructActivityObject: () ->
        if @actor and @object and @verb then @activity =
            actor: @map(@actor)
            verb: @verb
            object: @map(@object)


    fireCallbacks: (cb) =>
        for i of cb
            cb[i].call @

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
        # @render()

    setActor: (actor) ->
        unless @actor == actor
            @actor = actor ? @actor
            @urls = @createUrls()
            @activity = @constructActivityObject @actor, @verb, @object

    ############
    # View Logic
    ############

    render: ->
        context =
            activity: @constructActivityObject()
            active: @active
            state: @state

        @el.innerHTML = @view(context)



    ###############
    # Event Binding
    ###############

    bindClick: () =>
        @el.onclick = (event) =>
            if @active is true
                @fireCallbacks(@activeCallbacks)
                @save()
                @toggleState()
            else
                @fireCallbacks(@inactiveCallbacks)

    ##############
    #Service Calls
    ##############
    fetch: ->
        # Only called when there is no Actor present
        ActivitySnippet.utils.getJSON @urls.get, 
                (data) =>
                    console.log data, data[0]
                    if data and data[0].items[0]
                        @toggleState()
                    # @parseFetch data
                    @render()
                ,
                (error) ->
                    console.error error


    save: () =>
        # POST api/v1/activity
        unless @state
            activity = @constructActivityObject()
            ActivitySnippet.utils.postJSON @urls.post, activity,
                (data) =>
                    # console.log data
                ,
                (error) =>
                    console.error error
        else
            ActivitySnippet.utils.del @urls.del,
                (data) =>
                    # console.log data
                ,
                (error) =>
                    console.error error
