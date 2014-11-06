module.exports = {
   selectors: {
    'watchedIconOne': '.activitysnippet:nth-child(2) span a i',
    'watchedIconTwo': '.activitysnippet:nth-child(3) span a i',
    'watchedIconThree': '.activitysnippet:nth-child(4) span a i',
    'favoritedIconOne': '.activitysnippet:nth-child(5) span a i',
    'favoritedIconTwo': '.activitysnippet:nth-child(6) span a i',
    'followedIcon': '.activitysnippet:nth-child(7) span a i',
    'watchedOneInnactive': '.activitysnippet:nth-child(2) .activitysnippet-icon--inactive',
    'watchedTwoInnactive': '.activitysnippet:nth-child(3) .activitysnippet-icon--inactive',
    'watchedThreeInnactive': '.activitysnippet:nth-child(4) .activitysnippet-icon--inactive',
    'favoritedOneInnactive': '.activitysnippet:nth-child(5) .activitysnippet-icon--inactive',
    'favoritedTwoInnactive': '.activitysnippet:nth-child(6) .activitysnippet-icon--inactive',
    'followedInnactive': '.activitysnippet:nth-child(7) .activitysnippet-icon--inactive',
    'watchedOneCount': '.activitysnippet:nth-child(2) .activitysnippet-count',
    'watchedTwoCount': '.activitysnippet:nth-child(3) .activitysnippet-count',
    'watchedThreeCount': '.activitysnippet:nth-child(4) .activitysnippet-count',
    'favoritedOneCount': '.activitysnippet:nth-child(5) .activitysnippet-count',
    'favoritedTwoCount': '.activitysnippet:nth-child(6) .activitysnippet-count',
    'followedCount': '.activitysnippet:nth-child(7) .activitysnippet-count',
    'toggleActive': '#toggleActive',
    'user': '#user'
  },

  load: function () {
    return this.client
      .url('http://as.dev.nationalgeographic.com:9001/')
      .waitForElementVisible('body', 3000)
      .assert.title('modules activitysnippet')
      .setCookie({
        name     : "mmdbsessionid",
        value    : "0h2vi9ca348p03wr0h76c6htgxp1j3pf",
        path     : "/", 
        domain   : ".nationalgeographic.com",
        secure   : false
      })
      .pause(2000);
  },

  search: function (query) {
    return this.client
      .click(this.selectors.snippetIcon)
      .pause(2000)
      .getText(this.selectors.snippetCount, function(result){
        this.assert.equal(result.value, "1")
      })
      .assert.containsText(this.selectors.snippetCount,"1")
      .click(this.selectors.snippetIcon)
      .pause(2000)
      .assert.containsText(this.selectors.snippetCount,"0")
      .click(this.selectors.toggleActive)
      .pause(2000)
      .waitForElementVisible(this.selectors.snippetIconInnactive, 3000)
      .assert.visible(this.selectors.snippetIcon)
      //.assert.visible('input[type=text]')
      //.setValue('input[type=text]', query)
      //.waitForElementVisible('input[name=go]', 1000)
      //.click('input[name=go]')
      .pause(1000);
  },

  toggleState: function(){
    return this.client
    .click(this.selectors.toggleActive)
    .pause(2000);
  },

  isUserActive: function(active) {
    if (active){
      return this.client
      .waitForElementVisible(this.selectors.watchedIconOne, 3000)
      .waitForElementVisible(this.selectors.watchedIconTwo, 3000)
      .waitForElementVisible(this.selectors.watchedIconThree, 3000)
      .waitForElementVisible(this.selectors.favoritedIconOne, 3000)
      .waitForElementVisible(this.selectors.favoritedIconTwo, 3000)
      .waitForElementVisible(this.selectors.followedIcon, 3000)
  }else{
      return this.client
      .waitForElementVisible(this.selectors.watchedOneInnactive, 3000)
      .waitForElementVisible(this.selectors.watchedTwoInnactive, 3000)
      .waitForElementVisible(this.selectors.watchedThreeInnactive, 3000)
      .waitForElementVisible(this.selectors.favoritedOneInnactive, 3000)
      .waitForElementVisible(this.selectors.favoritedTwoInnactive, 3000)
      .waitForElementVisible(this.selectors.followedInnactive, 3000)
    };
  },

  clickSnippet: function (){
    return this.client
    .click(this.selectors.watchedIconOne)
    .click(this.selectors.watchedIconTwo)
    //.click(this.selectors.watchedIconThree)
    .click(this.selectors.favoritedIconOne)
    .click(this.selectors.favoritedIconTwo)
    .click(this.selectors.followedIcon)
    .pause(3000);
  },

  verifySnippetCount: function(count){
    return this.client
    .assert.containsText(this.selectors.watchedOneCount,count)
    .assert.containsText(this.selectors.watchedTwoCount,count)
    .assert.containsText(this.selectors.watchedThreeCount,count)
    .assert.containsText(this.selectors.favoritedOneCount,count)
    .assert.containsText(this.selectors.favoritedTwoCount,count)
    .assert.containsText(this.selectors.followedCount,count);
  }


};

