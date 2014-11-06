var path = require('path');

module.exports = {
  tags: ['sanity', 'search'],

  'Verb the object and see snipet count updated': function (client) {
    require('nightwatch-pages')(client, path.resolve(__dirname, '..', 'pages'));

    var clicked = "1";
    var unclicked = "0";

    client
      .page.snippet_page.load()
      .page.snippet_page.clickSnippet()
      .page.snippet_page.verifySnippetCount(clicked)
      .page.snippet_page.clickSnippet()
      .page.snippet_page.verifySnippetCount(unclicked)
      .end();
  }
};
