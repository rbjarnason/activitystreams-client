root = exports ? this

'use strict';

root.utils = {}

# DOM ready
utils.ready ?= (fn, context) ->
  fire = ->
    utils.ready.fired = true unless utils.ready.fired
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

utils.getJSON ?= (url, success, error) ->
    request = new XMLHttpRequest
    request.open "GET", url, true
    request.onreadystatechange = ->
        handleResponse.call @, success, error

    request.send()
    request = null

utils.post ?= (url, data, success, error) ->
    request = new XMLHttpRequest()
    request.open "POST", url, true
    request.onreadystatechange = ->
        handleResponse.call @, success, error

    request.send data
    request = null


utils.del ?= (url, data, succes, error) ->
    request = new XMLHttpRequest()
    request.open "DEL", url true
    request.onreadystatechange = ->
      handleResponse.call @, success, error

    request.send data
    request = null


utils.logger ?= (obj) ->
  console.log '------------'
  console.log( JSON.stringify obj)
  console.log '------------'

return utils
