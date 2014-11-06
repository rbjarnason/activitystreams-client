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
  },

  var snippets = [this.selectors.watchedIconOne, this.selectors.watchedIconTwo, this.selectors.watchedIconThree,
    this.selectors.favoritedIconOne, this.selectors.favoritedIconTwo, this.selectors.followedIcon];

  var snippetsCount = [this.selectors.watchedOneCount, this.selectors.watchedTwoCount, this.selectors.watchedThreeCount,
    this.selectors.favoritedOneCount, this.selectors.favoritedTwoCount, this.selectors.followedCount];

  var snippetsInactive = [this.selectors.watchedOneInnactive, this.selectors.watchedTwoInnactive, 
    this.selectors.watchedThreeInnactive, this.selectors.favoritedOneInnactive, this.selectors.favoritedTwoInnactive, 
    this.selectors.followedInnactive];   

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

  toggleState: function(){
    return this.client
    .click(this.selectors.toggleActive)
    .pause(2000);
  },

  clickSnippet: function (){
    for (var i = 0; i < snippets.length; i++) {
      this.client
      .click(snippets[i])
    };
    return this.client
    .pause(2000);
  },

  isUserActive: function(active) {
    for (var i = 0; i < this.snippets.length; i++) {
      if (active){
        this.client
        .waitForElementVisible(this.snippets[i], 3000)
      }else{
       this.client
       .waitForElementVisible(this.snippetsInactive[i], 3000)
       .click(this.snippets[i])
       .pause(500)
       .assert.containsText(this.snippetsCount[i],"0")
      }
    };
    return this.client
    .pause(1000);
  },

  verifySnippetCount: function(count){
    for (var i = 0; i < this.snippetsCount.length; i++) {
      this.client
      .assert.containsText(this.snippetsCount[i],count)
    };
    return this.client
    .pause(1000);
  }

};

