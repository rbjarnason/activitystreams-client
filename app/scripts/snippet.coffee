'use strict';

root = exports ? this

class root.ActivityStreamSnippet
	constructor: (el) ->
		@verb = el.getAttribute('data-verb')
		@id = el.getAttribute('data-id')
		@object = 
			id: el.getAttribute('data-object-id')
			type: el.getAttribute('data-object-type')
			api: el.getAttribute('data-object-api')
		console.log @id

	fetch: (actor) ->
		console.log 'fetch'