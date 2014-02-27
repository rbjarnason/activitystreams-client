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

        # Activity``
        @actor = actor ? null
        @verb = el.getAttribute('data-verb').toUpperCase()
        @object = @constructObject(el)
        @count = 0

        #urls
        @urls = @createUrls()



        # Init View
        @view = templates['app/scripts/templates/' + @verb + '.handlebars']
        @render()


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
            api: el.getAttribute('data-object-api') + '/' + id + '/'
        obj


    convertIdToTypeId: (obj) ->
        #oh my god global objects are soo evil
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


    ############
    # State Management
    ############
    toggleActive: ->
        @active = !@active
        @render()


    toggleActivityState: ->
        console.log @activityState
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
                    #this is my activity
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

        console.log context 
        @el.innerHTML = @view(context)


    init:  (data) =>
        @object.counts = 0
        @render()


    ###########
    # Event Binding
    ###########

    bindClick: () =>
        @el.onclick = (event) =>
            @save(@activityObject)
            @toggleActivityState()


    ###############
    #Service Calls
    ################

    fetch: ->
        # Only Called when there is no Actor present
        url = [@service, @object.type, @object.id, @verb].join('/') 
        ActivitySnippet.utils.getJSON url, 
                (data) =>
                    @init data
                ,
                (error) ->
                    console.log error


    save: (activity) =>

        console.log @activityState
        # POST api/v1/activity
        unless @activityState
            ActivitySnippet.utils.postJSON @urls.post, activity,
                (data) =>
                    console.log data
                ,
                (error) =>
                    console.log error
        else
            ActivitySnippet.utils.del @urls.del,
                (data) =>
                    console.log data 
                ,
                (error) =>
                    console.log error
