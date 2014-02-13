'use strict';

console.log 'Allo Allo'

root = exports ? this

ready ->
    class root.ActivityStreamSnippetFactory
        constructor: ->
            @count = 0
            @collection = []
            @user = null
            snippets = document.querySelectorAll('.activitysnippet')
            for i of snippets
                if snippets.hasOwnProperty(i) and i != 'length'
                    snippets[i].setAttribute('data-hash', 'as' + @count)
                    @collection.push(snippets[i])
                    @count++

        init: (options) ->
            # console.log @count, @collection, 'Howdy'