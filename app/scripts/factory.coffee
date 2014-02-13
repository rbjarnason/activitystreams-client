'use strict';

console.log 'Allo Allo'

root = exports ? this

ready ->
    class root.ActivityStreamSnippetFactory
        snippets = document.querySelectorAll('.activitysnippet')

        constructor: ->
            @count = 0
            @collection = []
            @user = null
            
        init: (options) ->
            for i of snippets
                if snippets.hasOwnProperty(i) and i != 'length'
                    snippets[i].setAttribute('data-id', 'as' + @count)
                    @collection.push new ActivityStreamSnippet(snippets[i])
                    @count++