'use strict';

console.log 'Allo Allo'

root = exports ? this

class root.ActivityStreamSnippet
    constructor: ->
        @count = 0
        @collection = []
        @user = null

    init: (options) ->
        ready @, ->
            snippets = document.querySelectorAll('.activitysnippet');
            for i of snippets
                if snippets.hasOwnProperty(i) and i != 'length'
                    snippets[i].setAttribute('data-id', 'as' + @count);
                    @collection.push(snippets[i])
                    @count++
                    console.log @collection
            console.log @count, @collection, 'Howdy'
