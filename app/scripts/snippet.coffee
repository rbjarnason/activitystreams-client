'use strict';

root = exports ? this

class root.ActivityStreamSnippet
	constructor: (el, options) ->
		@service = options.ActivityStreamAPI
        @actor = options.actor
        @verb = el.getAttribute('data-verb')
		@id = el.getAttribute('data-id')
		@object =
			id: el.getAttribute('data-object-id')
			type: el.getAttribute('data-object-type')
			api: el.getAttribute('data-object-api')

	fetch: ->
        getJSON , ((data) ->
          return data
        ), (error) ->
          return error
