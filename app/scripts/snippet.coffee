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
        @activeCallbacks = settings.activeCallbacks ? []
        @inactiveCallbacks = settings.inactiveCallbacks ? []

        # Activity
        @actor = actor ? null
        @verb = el.getAttribute('data-verb').toUpperCase()
        @object = @constructObject(el)
        @count = 0

        #urls
        @urls = @createUrls()

        # Init View
        @view = templates['app/scripts/templates/' + @verb + '.handlebars']
        @render()
        @bindClick()


    ############
    # Helper Methods
    ############

    createUrls: ->
        urls = {}
        urls.get = "#{@service}/#{@object.type}/#{@object.id}/#{@verb}"
        if @actor
            urls.post = "#{@service}/activity"
            urls.del =  "#{@service}/#{@actor.type}/#{@actor.id}/#{@verb}/#{@object.type}/#{@object.id}"
        urls


    constructObject: (el) ->
        id = el.getAttribute('data-object-id')

        obj = 
            id: id
            type: el.getAttribute('data-object-type')
            api: el.getAttribute('data-object-api') + id + '/'
        obj


    convertIdToTypeId: (obj) ->
        newObj = ActivitySnippet.utils.extend({}, obj)
        newObj[newObj.type + '_id'] = newObj.id
        delete newObj['id']
        newObj


    constructActivityObject: (actor, verb, object) ->
        actor = @convertIdToTypeId(actor)
        object = @convertIdToTypeId(object)
        activity =
            actor: actor
            verb:
                type: verb
            object: object

        activity

    fireCallbacks: (cb) =>          
        for i of cb
            cb[i].call @

    ############
    # State Management
    ############
    toggleActive: ->
        @active = !@active
        @render()


    toggleActivityState: ->
        # Toggle activityState for items user has interacted with
        # Runs when snippet first loads and knows which items should be active
        # Toggles activityState flag on a particular snippet when clicked
        @activityState = !@activityState
        @render()

    setActor: (actor) ->
        unless @actor == actor
            @actor = actor ? @actor
            @urls = @createUrls()
            @activityObject = @constructActivityObject @actor, @verb, @object
        @bindClick()

    selfIdentify: (data) ->
        for obj in data
            if obj['object']['data']['type'] is @object.type and obj['verb']['type'] is @verb
                if obj['object']['data'][@object.type + '_id'] is @object.id
                    # Toggle the snippet state
                    @toggleActivityState()
                    break

    ############
    # View Logic
    ############

    render: ->
        @activity =
            actor: @actor
            verb: @verb
            object: @object
        context =
            activity: @activity
            active: @active

        if @activityState
            context.activityState = 'activited'

        @el.innerHTML = @view(context)

    init:  (data) =>
        @object.counts = 0
        @render()


    ###########
    # Event Binding
    ###########

    bindClick: () =>
        @el.onclick = (event) =>
            if @active is true
                @fireCallbacks(@activeCallbacks)
                @save(@activityObject)
                @toggleActivityState()
            else
                @fireCallbacks(@inactiveCallbacks)

    ###############
    #Service Calls
    ################
    fetch: ->
        # Only called when there is no Actor present
        url = [@service, @object.type, @object.id, @verb].join('/') 
        ActivitySnippet.utils.getJSON url, 
                (data) =>
                    @init data
                ,
                (error) ->
                    console.error error


    save: (activity) =>
        # POST api/v1/activity
        unless @activityState
            ActivitySnippet.utils.postJSON @urls.post, activity,
                (data) =>
                    console.log data
                ,
                (error) =>
                    console.error error
        else
            ActivitySnippet.utils.del @urls.del,
                (data) =>
                    console.log data 
                ,
                (error) =>
                    console.error error
