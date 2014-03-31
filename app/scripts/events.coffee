'use strict';

root = exports ? this
root.ActivitySnippet = ActivitySnippet ? {}

class ActivitySnippet.Events
    ###*
     * A class that allows simple message passing
     * There needs to be a 'transport' object that will maintain
     * the list of channels and listeners. Based on Backbone's
     * events module.
    ###



    ###*
     * Pushes callbacks and context to an event object collection
     *  with a channel namespace
     * @param  {string}   channel  the channel / namespace to listen to
     * @param  {Function} callback the callback function
     * @param  {object}   context  context 'this' used when calling the callback
    ###
    on: (channel, callback, context) ->
        if not callback then return @
        @_events = @_events or {}
        events = @_events[channel] or (@_events[channel] = [])
        events.push callback: callback, context: context, ctx: context or @

        @

    off: (name, callback, context) ->
        if not @_events then return @
        if not name and not callback and not context
            @_events = undefined
            return @

        names = if name then [name] else Object.keys @_events
        for name in names
            if events = @_events[name]
                @_events[name] = retain= []
                if callback or context
                    for event in events
                        if (callback and callback isnt event.callback) or (context and context isnt event.context)
                            retain.push event
                if not retain.length then delete @_events[name]

        @

    ###*
     * Allows the object you calling this on to register a callback with a transport object
     * @param  {Object}   transport the transport object that will contain the messages
     * @param  {string}   channel   namespaced channel/event you wish to listen to
     * @param  {Function} callback callback that will be fired when the an event has been sent to the channel
    ###
    listenTo: (transport, channel, callback) ->
        listeningTo = @_listeningTo or (@_listeningTo = {})
        id = object._id or (object._id = (new Date()).getTime())
        listeningTo[id] = object
        object.on channel, callback, @

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

    ###*
     * determines what namespaced event callbacks should be fired
     *
     * @param  {string} name namespaced channel/event
     * @param  {object} arg argument object passed to the calllback
    ###
    trigger: (name, arg) ->
        if not @_events then return @
        events = @_events[name]
        allEvents = @_events["*"]
        if events then trigger events, arg, name
        if allEvents then trigger allEvents, arg, name

        @

###*
 * Triggers all callbacks registed to a specfic channel
 * @param  {object} events collection of event objects
 * @param  {object} arg     arg object to pass to the callback
 * @param  {strign} name    the name of the namespaced event
###
trigger = (events, arg, name) ->
    for event in events
        event.callback.call event.ctx, arg, name
