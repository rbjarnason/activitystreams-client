describe 'Unit Testing Activity Stream Factory', ->

    #Global Test Variables Here
    snippetFactory = null
    options = {}
    #put beforeEach and afterEach hooks here

    beforeEach ->

      options =
        debug: false
        user:
            loggedIn: user.loggedIn
            loggedOut: user.loggedOut
        actor:
            id: 1
            type: 'mmdb_user'
            api: 'http://mmdb.dev.nationalgeographic.com:8000/api/v1/user/1/'
        ActivityStreamAPI: 'http://as.dev.nationalgeographic.com:9365/api/v1'


    afterEach ->

      snippetFactory = null
      options = {}

    it 'should require that ActivityStreamAPI be passed in on instantiation', ->
        expect(new ActivitySnippet.ActivityStreamSnippetFactory()).to.throw(new Error('SnippetFactory:: Must pass in ActivityStreamAPI'))

    it 'should have some internal defaults', ->
        snippetFactory = new ActivitySnippet.ActivityStreamSnippetFactory()
        snippetFactory.settings.should.have.property('debug')
        expect(snippetFactory.settings.debug).to.be.false

    it 'should allow for overriding the internal defaults by accepting config', ->
        snippetFactory = new ActivitySnippet.ActivityStreamSnippetFactory({debug:true})
        snippetFactory.settings.should.have.property('debug')
        expect(snippetFactory.settings.debug).to.be.true


    it 'should not be able to initialize without the service endpoint', ->
        snippetFactory = new ActivitySnippet.ActivityStreamSnippetFactory(options)
        snippetFactory.should.have.property('user')


    it 'should be able to create snippets', ->
      # currently index.html contains snippet elements
      snippetFactory.should.have.property('snippets').with.length(3)


    it 'should bind event listners to userLoggedIn and userLogged Out', ->




    it 'should make ajax call to Activity Stream Service and get all of users activies', ->

      user =
        id: 1




    it 'should be able to pass user status to snippets', ->


