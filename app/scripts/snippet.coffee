'use strict';

class ActivityStreamSnippet
    @length = 0
    @collection = []

    constructor: ->
        snippets = document.querySelectorAll('.activitysnippet');
        for i of snippets
            console.log i
