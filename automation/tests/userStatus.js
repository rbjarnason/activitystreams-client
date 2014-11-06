var path = require('path');

module.exports = {
  tags: ['sanity', 'search'],

  'Toggle user state': function (client) {
    require('nightwatch-pages')(client, path.resolve(__dirname, '..', 'pages'));

    client
      .page.snippet_page.load()
      .page.snippet_page.toggleState()
      .page.snippet_page.isUserActive(false)
      .page.snippet_page.clickSnippet()
      .page.snippet_page.verifySnippetCount("0")
      .page.snippet_page.toggleState()
      .page.snippet_page.isUserActive(true)
      .page.snippet_page.clickSnippet()
      .end();
  }
};
