'use strict';

root = exports ? this
root.ActivitySnippet = ActivitySnippet ? {}

class ActivitySnippet.Events

    on: (name, callback, context) ->
        if not callback then return @
        @_events = @_events or {}
        events = @_events[name] or (@_events[name] = [])
        events.push callback: callback, context: context, ctx: context or @

        @

    off: (name, callback, context) ->
        if not @_events then return @
        if not name and not callback and not context
            @_events = undefined

        names = if name then [name] else Object.keys @_events
        for name in names
            if events = @_events[name]
                @_events = retain= []
                if callback or context
                    for event in events
                        if (callback and callback isnt event.callback) or (context and context isnt event.context)
                            retain.push event
                if not retain.length then delete @_events[name]

        @

    listenTo: (object, name, callback) ->
        listeningTo = @_listeningTo or (@_listeningTo = {})
        id = object._id or (object._id = (new Date()).getTime())
        listeningTo[id] = object
        object.on name, callback, @

        @

    stopListening: (object, name, callback) ->
        listeningTo = @_listeningTo
        if not listeningTo then return @
        remove = not name and not callback
        if object then (listeningTo = {})[object._id] = object
        for id of listeningTo
            object = listeningTo[id]
            object.off name, callback, @
            if remove or not Object.keys(object._events).length then delete @_listeningTo[id]

        @

    trigger: (name, arg) ->
        if not @_events then return @
        events = @_events[name]
        allEvents = @_events["*"]
        if events then trigger events, arg, name
        if allEvents then trigger allEvents, arg, name

        @

trigger = (events, arg, name) ->
    for event in events
        event.callback.call event.ctx, arg, name
