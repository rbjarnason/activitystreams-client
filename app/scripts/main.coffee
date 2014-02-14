#/*global require*/
'use strict'

# Main RequireJS properties loaded on init:
require.config
  shim:
    handlebars:
      exports: 'Handlebars'
    utils:
      exports: 'utils'
    templates:
      exports: 'JST'
  paths:
    handlebars: '../bower_components/handlebars/handlebars'
    utils: 'utils'
    ActivityStreamSnippet: 'snippet'
    ActivityStreamSnippetFactory: 'factory'

require [
  'ActivityStreamSnippetFactory',
  'templates'
], (ActivityStreamSnippetFactory, templates) ->
  window.snippet = new ActivityStreamSnippetFactory()
  snippet.init({ ActivityStreamAPI: 'http://as.dev.nationalgeographic.com:9365/api/v1', actor: { id: '1', type: 'mmdb_user' }  });
