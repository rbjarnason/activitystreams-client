define [
    'utils',
    'handlebars',
    'templates'
], (utils, ActivityStreamSnippet, JST) ->

    'use strict';

    class ActivityStreamSnippet
        constructor: (el, templates) ->
            @el = el
            @verb = el.getAttribute('data-verb')
            @view = templates['app/scripts/templates/' + @verb + '.handlebars']
            @id = el.getAttribute('data-id')
            @object =
                id: el.getAttribute('data-object-id')
                type: el.getAttribute('data-object-type')
                api: el.getAttribute('data-object-api')
            @render()

        fetch: ->
            verb = @verb.toUpperCase()
            url = [@service,@actor.type,@actor.id,verb,@object.type,@object.id].join('/')
            utils.getJSON url, (data) ->
              return data
            , (error) ->
              return error

        render: ->
            @activity =
                actor: @actor
                verb: @verb
                object: @object
            @el.innerHTML = @view(@activity)

        init: (options) ->
            @service = options.ActivityStreamAPI
            @actor = options.actor
