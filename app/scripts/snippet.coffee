'use strict';

console.log 'Allo Allo'

root = exports ? this

class root.ActivityStreamSnippet
    constructor: ->
        @count = 0
        @collection = []
        @user = null
        snippets = document.querySelectorAll('.activitysnippet');
        for i of snippets
            if snippets.hasOwnProperty(i) and i != 'length'
                snippets[i].setAttribute('data-id', 'as' + @count);
                @collection.push(snippets[i])
                @count++
                console.log @collection
    init: (options) ->
        console.log @count, @collection, 'Howdy'
