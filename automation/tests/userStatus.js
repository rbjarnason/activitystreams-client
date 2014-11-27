var path = require('path');

module.exports = {
  tags: ['sanity', 'search'],

  'Toggle user state': function (client) {
    require('nightwatch-pages')(client, path.resolve(__dirname, '..', 'pages'));

    client
      .page.home_page.load()
      .page.home_page.toggleState()
      .page.home_page.isUserActive(false)
      .page.home_page.clickSnippet()
      .page.home_page.verifySnippetCount("0")
      .page.home_page.toggleState()
      .page.home_page.isUserActive(true)
      .page.home_page.clickSnippet()
      .end();
  }
};
