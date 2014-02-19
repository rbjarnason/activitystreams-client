describe 'Unit Testing Activity Stream Factory', ->

    #Global Test Variables Here
    snippetManager = null

    #put beforeEach and afterEach hooks here

    beforeEach ->

      options =
        debug: true

       snippetManager = new ActivityStreamSnippetManager(options)

    afterEach ->

      snippetManager = null


    it 'should be able to take configuration options and have default parameters', ->

      snippetManager.options.debug.should.equal true
      snippetManager.options.activityStreamAPI.should.equal 'http://as.dev.nationalgeographic.com:9365/api/v1'
      snippetManager.options.snippetClass.should.equal '.activitysnippet'


    it 'should be able to create snippets', ->
      # currently index.html contains snippet elements
      snippetManager.should.have.property('snippets').with.length(3)


    it 'should bind event listners to userLoggedIn and userLogged Out', ->




    it 'should make ajax call to Activity Stream Service and get all of users activies', ->

      user =
        id: 1




    it 'should be able to pass user status to snippets', ->


