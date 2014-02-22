'use strict';

root = exports ? this
root.ActivitySnippet = ActivitySnippet ? {}

class ActivitySnippet.ActivityStreamSnippet
    constructor: (el, templates) ->


        unless el?
            throw new Error('Need Html Element')


        @el = el
        @verb = el.getAttribute('data-verb')
        @view = templates['app/scripts/templates/' + @verb + '.handlebars']
        @id = el.getAttribute('data-id')
        @count = 0
        @object =
            id: el.getAttribute('data-object-id')
            type: el.getAttribute('data-object-type')
            api: el.getAttribute('data-object-api')
        @render()

    save: ->
        url = [@service, @object.type, @object.id, @verb].join('/')
        ActivitySnippet.utils.getJSON url, (data) ->
          return data
        , (error) ->
          return error

    render: ->
        @activity =
            actor: @actor
            verb: @verb
            object: @object

        @el.innerHTML = @view(@activity)

    init:  (data) =>
        @object.counts = 0
        @render()
           
    fetch: ->

        activityStreamApi = 'http://as.dev.nationalgeographic.com:9365/api/v1'
        actor = @object.type
        actor_id = @object.id
        verb = @verb.toUpperCase()
        url = "#{ activityStreamApi }/#{ actor }/#{ actor_id }/#{ verb }"

        ActivitySnippet.utils.getJSON url, 
                (data) => 
                    @init(data) 
                ,
                (error) ->
                    console.log error


