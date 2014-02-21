'use strict';

root = exports ? this
root.ActivitySnippet = ActivitySnippet ? {}

class Utils
    # DOM ready
    ready: (fn, context) ->
      fire = ->
        ActivitySnippet.utils.ready.fired = true unless ActivitySnippet.utils.ready.fired
        fn.apply context

      return fire() if document.readyState is "complete"

      # Mozilla, Opera, WebKit
      if document.addEventListener
        document.addEventListener "DOMContentLoaded", fire, false
        window.addEventListener "load", fire, false

      # IE
      else if document.attachEvent
        check = ->
          try
            document.documentElement.doScroll "left"
          catch e
            setTimeout check, 1
            return
          fire()
        document.attachEvent "onreadystatechange", fire
        window.attachEvent "onload", fire
        check() if document.documentElement and document.documentElement.doScroll and !window.frameElement


    handleResponse= (success, error) ->
        if @readyState is 4
            if @status >= 200 and @status < 400

              # Success!
              responseData = JSON.parse(@responseText)
              success responseData 
            else
              # Error :(
              responseError = @status + ' ' + @statusText
              error responseError 

          return

    getJSON: (url, success, error) ->
        request = new XMLHttpRequest
        request.open "GET", url, true
        request.onreadystatechange = ->
            handleResponse.call @, success, error  

        request.send()
        request = null

    post: (url, data, success, error) ->
        request = new XMLHttpRequest()
        request.open "POST", url, true
        request.onreadystatechange = ->
            handleResponse.call @, success, error

        request.send data
        request = null

    extend: (args...) ->
      return {} if not args[0]?
      for i of args
        for own key, val of args[i]
          if not args[0][key]? and typeof val isnt "object"
            args[0][key] = val
          else
            args[0][key] = @extend args[0][key], val

      args[0]


    del: (url, data, succes, error) ->
        request = new XMLHttpRequest()
        request.open "DEL", url true
        request.onreadystatechange = ->
          handleResponse.call @, success, error

        request.send data
        request = null


    logger: (obj) ->
      console.log '------------'
      console.log( JSON.stringify obj)
      console.log '------------'

ActivitySnippet.utils = new Utils()
