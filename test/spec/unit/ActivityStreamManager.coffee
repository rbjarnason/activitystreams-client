describe 'Unit Testing Activity Stream Factory', ->

    #Global Test Variables Here
    snippetFactory = null

    #put beforeEach and afterEach hooks here

    beforeEach ->

      options =
        debug: true

      snippetFactory = new ActivityStreamSnippetFactory(options)

    afterEach ->

        snippetFactory = null


    it 'should be able to take configuration options and have default parameters', ->

      snippetFactory.options.debug.should.equal true
      snippetFactory.options.activityStreamAPI.should.equal 'http://as.dev.nationalgeographic.com:9365/api/v1'
      snippetFactory.options.snippetClass.should.equal '.activitysnippet'


    it 'should be able to create snippets', ->
      # currently index.html contains snippet elements
      snippetFactory.should.have.property('snippets').with.length(3)
      snippetFactory.should.have.property('collection').with.length(3)



    it 'should be able to call pass user down to snippets', ->
      {}.to.throw()


