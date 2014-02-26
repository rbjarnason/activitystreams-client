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


    describe 'Service Calls', ->

        beforeEach ->
            @xhr = sinon.useFakeXMLHttpRequest()
            requests = @requests = []

            @xhr.onCreate = (xhr) ->
                requests.push(xhr)

        afterEach ->
            @xhr.restore()


        it 'should be able to construct fetch url', ->

        it 'should be able to construct fetch url given an actor', ->

        it 'should be able to construct JSON object for saving', ->

        it 'should be able to fetch empty data', ->

            callback = sinon.spy()
            snippet.fetch callback 
            expect(@requests.length).to.equal 1

            @requests[0].respond( 200, {'Content-Type': 'application/json'}, '[]')

            expect(callback.called).to.be.true
            expect(callback).to.have.been.calledWith([])

        it 'should be able to fetch some data', ->

            callback = sinon.spy()

            snippet.fetch callback 
            expect(@requests.length).to.equal 1

            @requests[0].respond( 200, {'Content-Type': 'application/json'}, '[{"totalCount": 1112}]')

            expect(callback.called).to.be.true
            expect(callback).to.have.been.calledWith([{totalCount: 1112}])

        it 'should be able to fetch data given an actor', ->

            actor =
                id: 1
                type: 'mmdb_user'
                api: 'http://some.api.com'

            snippet.setActor actor

            callback = sinon.spy()
            snippet.fetch callback 
            expect(@requests.length).to.equal 1

            @requests[0].respond( 200, {'Content-Type': 'application/json'}, '[{"totalCount": 1112, "activityState": true }]')

            expect(callback.called).to.be.true
            expect(callback).to.have.been.calledWith([{totalCount: 1112, activityState: true }])


        it 'should be able to post a new activity given an actor', ->
            actor =
                id: 1
                type: 'mmdb_user'
                api: 'http://some.api.com'

            snippet.setActor actor

            callback = sinon.spy()

            activity =
                actor: actor
                verb: snippet.verb.toUpperCase()
                object:
                    type: snippet.object.type
                    id: snippet.object.id
                    api: snippet.object.api

            jsonActivity = JSON.stringify(activity)

            snippet.save callback 
            expect(@requests.length).to.equal 1


            @requests[0].respond( 200, {'Content-Type': 'application/json'}, jsonActivity)

            expect(callback.called).to.be.true
            expect(callback).to.have.been.calledWith([{totalCount: 1112, activityState: true }])


    describe 'View Rendering', ->


        it 'should be able to update view given new counts', ->

        it 'should be able to return 0 counts', ->





















