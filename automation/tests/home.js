var path = require('path');

module.exports = {
  tags: ['sanity'],

  'Load module': function (client) {
    require('nightwatch-pages')(client, path.resolve(__dirname, '..', 'pages'));

    var searchTerm = 'selenium';
    var count = "1";

    client
      .page.snippet_page.load()
      .page.snippet_page.toggleState()
      .page.snippet_page.isUserActive(false)
      .page.snippet_page.clickSnippet()
      .page.snippet_page.verifySnippetCount("0")
      .page.snippet_page.toggleState()
      .page.snippet_page.isUserActive(true)
      .page.snippet_page.clickSnippet()

      //.page.home_page.load()
      //.page.home_page.clickSnippet()
      //.page.home_page.verifySnippetCount(count)
      //.page.home_page.clickSnippet()
      //.page.home_page.verifySnippetCount("0")
      //.page.home_page.toggleState()
      //.page.home_page.isUserActive(false)
      //.page.home_page.toggleState()
      //.page.home_page.isUserActive(true)
      //.page.homepage.search(searchTerm)
      //.page.search_results.assertResults(searchTerm)
      //.page.search_results.navImages()
      //.saveScreenshot('./results/screenshots/screen2.png')
      .end();
  }
};
