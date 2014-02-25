describe 'Unit Testing of Activty Stream Snippet', ->

    snippet = null

    beforeEach ->

        element = document.querySelector '.activitysnippet'
        templates = ActivitySnippet.ActivitySnippetTemplates
        settings =
            debug: true
            ActivityStreamAPI: 'http://as.dev.nationalgeographic.com:9365/api/v1/'

        snippet = new ActivitySnippet.ActivityStreamSnippet(element, settings, templates) 

    afterEach ->
        snippet = null 


    describe 'Instantization', ->

        it ' Takes an element, ActivityStreamAPI and templates objects', ->

            expect(snippet.el).to.be.ok
            expect(snippet.view).to.be.ok
            expect(snippet.service).to.be.ok

        it 'should throw excpetion when element is not passed in', ->

            snippet = () ->
                new ActivitySnippet.ActivityStreamSnippet()
            expect(snippet).to.throw(/Need Html Element/)

        it 'should throw exception when templates object is not passed in', ->
            element = document.querySelector '.activitysnippet'
            snippet = () ->
                new ActivitySnippet.ActivityStreamSnippet(element)
            expect(snippet).to.throw(/Need Templates Object/)

        it 'should throw exception when setting object is not passed in', ->
            element = document.querySelector '.activitysnippet'
            templates = ActivitySnippet.ActivitySnippetTemplates

            snippet = () ->
                new ActivitySnippet.ActivityStreamSnippet(element, {}, templates)
            expect(snippet).to.throw(/Need ActivityStreamAPI endpoint/)


    describe 'State Management', ->
        
        it 'should be able to toggle active state', ->

            expect(snippet.active).to.be.true
            snippet.toggleActive()
            expect(snippet.active).to.be.false
            snippet.toggleActive()
            expect(snippet.active).to.be.true

        it 'should be able to set actor', ->
            actor =
                id: 1
                type: 'mmdb_user'
                api: 'http://some.api.com'

            expect(snippet.actor).to.be.null
            snippet.setActor actor
            expect(snippet.actor).to.deep.equal(actor)



    describe 'Server Calls', ->

        server = null
        before ->
            server = sinon.fakeServer.create()
            server.autoRespond = true

        after ->
            server.restore()

        it 'should be able to fetch empty data', ->

            spy = sinon.spy()

            server.respondWith('GET', '/api/v1/ngm_article/1/FAVORITED',
                [200, {'Content-Type': 'application/json'}, '[]']
            )

            snippet.fetch(spy)

