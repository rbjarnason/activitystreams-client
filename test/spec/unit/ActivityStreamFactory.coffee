describe 'Unit Testing Activity Stream Factory', ->

    #Global Test Variables Here
    snippetFactory = null

    #put beforeEach and afterEach hooks here

    beforeEach ->

        options =
            debug: true

        nodeList = document.querySelectorAll '.activitysnippet'
        for node in nodeList
            console.log node


        snippetFactory = new ActivitySnippet.ActivityStreamSnippetFactory()


    it 'should be able to take configuration options and have default parameters', ->


    it 'should be able to create snippets', ->
      # currently index.html contains snippet elements
        snippetFactory.should.have.property('snippets')
        console.log snippetFactory.snippets.length
       



    it 'should be able to fetch data from Service Layer', ->






    it 'should bind event listners to userLoggedIn and userLogged Out', ->




    it 'should make ajax call to Activity Stream Service and get all of users activies', ->


    it 'should be able to pass user status to snippets', ->


