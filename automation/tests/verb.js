var path = require('path');

module.exports = {
  tags: ['sanity', 'search'],

  'Verb the object and see snipet count updated': function (client) {
    require('nightwatch-pages')(client, path.resolve(__dirname, '..', 'pages'));

    var clicked = "1";
    var unclicked = "0";

    client
      .page.home_page.load()
      .page.home_page.clickSnippet()
      .page.home_page.verifySnippetCount(clicked)
      .page.home_page.clickSnippet()
      .page.home_page.verifySnippetCount(unclicked)
      .end();
  }
};
