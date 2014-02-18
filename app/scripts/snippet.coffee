root = exports ? this

'use strict';

class root.ActivityStreamSnippet
    constructor: (el, templates) ->
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

