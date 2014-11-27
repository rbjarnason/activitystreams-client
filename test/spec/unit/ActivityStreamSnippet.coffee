describe 'Unit Testing of Activty Stream Snippet', ->

    snippet = null

    beforeEach ->
        element = document.querySelector '.activitysnippet'
        templates = ActivitySnippet.ActivitySnippetTemplates
        settings =
            debug: true
            ActivityStreamAPI: 'http://localhost:9365/api/v1'
        factory = new ActivitySnippet.ActivityStreamSnippetFactory settings

        snippet = new ActivitySnippet.ActivityStreamSnippet(element, settings, templates, [], [], factory)

    afterEach ->
        snippet = null


    describe 'Instantization', ->

        it 'Takes an element, ActivityStreamAPI and templates objects', ->
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

        it 'should be able to toggle state', ->
            snippet.toggleState true
            expect(snippet.state).to.be.true
            snippet.toggleState false
            expect(snippet.state).to.be.false
            snippet.toggleState()
            expect(snippet.state).to.be.true
            snippet.toggleState()
            expect(snippet.state).to.be.false
            snippet.toggleState false
            expect(snippet.state).to.be.false

        it 'should be able to set actor', ->
            actor =
                id: 1
                type: 'db_user'
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
            snippet.fetch callback()
            expect(@requests.length).to.equal 1

            @requests[0].respond( 200, {'Content-Type': 'application/json'}, '[]')

            expect(callback.called).to.be.true
            expect(@requests[0].responseText).to.contain('[]')

        it 'should be able to fetch some data', ->

            callback = sinon.spy()
            snippet.fetch callback()
            expect(@requests.length).to.equal 1

            @requests[0].respond( 200, {'Content-Type': 'application/json'}, '[{"totalCount": 1112}]')

            expect(callback.called).to.be.true
            expect(@requests[0].responseText).to.contain('[{"totalCount": 1112}]')

        it 'should be able to fetch data given an actor', ->

            actor =
                aid: 1
                type: 'db_user'
                api: 'http://some.api.com'

            snippet.setActor actor

            callback = sinon.spy()
            snippet.fetch callback()
            expect(@requests.length).to.equal 1

            @requests[0].respond( 200, {'Content-Type': 'application/json'}, '[{"totalCount": 1112, "activityState": true }]')

            expect(callback.called).to.be.true
            expect(@requests[0].responseText).to.contain('[{"totalCount": 1112, "activityState": true }]')

        it 'should call success callback on successful request to fetch an activity', ->
            callback = sinon.spy()
            callback2 = sinon.spy()
            actor =
                aid: 1
                type: 'db_user'
                api: 'http://some.api.com'
            snippet.setActor actor

            snippet.fetchActivityForUser
                success: (data) ->
                    callback()
                    expect(data[0]["actor"]["aid"]).to.equal 1
                error: callback2

            @requests[0].respond( 200, {'Content-Type': 'application/json'}, '[{"actor":{"aid":1},"verb":{"verb":"FAVORITED" },"object":{"aid":2}}]')

            expect(callback.called).to.be.true
            expect(callback2.called).to.be.false

        it 'should call error callback on failed request to fetch an activity', ->
            callback = sinon.spy()
            callback2 = sinon.spy()
            actor =
                aid: 1
                type: 'db_user'
                api: 'http://some.api.com'
            snippet.setActor actor

            snippet.fetchActivityForUser
                success: (data) ->
                    callback()
                error: (error) ->
                    callback2()
                    expect(error).to.equal '404 Not Found'

            @requests[0].respond(404, {}, "")

            expect(callback.called).to.be.false
            expect(callback2.called).to.be.true

        it 'should be able to post a new activity given an actor', ->
            actor =
                aid: 1
                type: 'db_user'
                api: 'http://some.api.com'

            snippet.setActor actor

            callback = sinon.spy()

            activity =
                actor: actor
                verb: snippet.verb.type.toUpperCase()
                object:
                    type: snippet.object.type
                    id: snippet.object.id
                    api: snippet.object.api

            jsonActivity = JSON.stringify(activity)

            snippet.save callback()
            expect(@requests.length).to.equal 1

            @requests[0].respond( 200, {'Content-Type': 'application/json'}, jsonActivity)

            expect(callback.called).to.be.true
            expect(@requests[0].responseText).to.contain(jsonActivity)

        it 'should call success callback on successful request', ->
            callback = sinon.spy()
            callback2 = sinon.spy()
            snippet.fetch
                success: (data) ->
                    callback()
                    expect(data[0]["totalCount"]).to.equal 1112
                error: callback2

            @requests[0].respond( 200, {'Content-Type': 'application/json'}, '[{"totalCount": 1112}]')

            expect(callback.called).to.be.true
            expect(callback2.called).to.be.false

        it 'should call error callback on failed request', ->
            callback = sinon.spy()
            callback2 = sinon.spy()
            snippet.fetch
                success: (data) ->
                    callback()
                error: (error) ->
                    callback2()
                    expect(error).to.equal '404 Not Found'

            @requests[0].respond(404, {}, "")

            expect(callback.called).to.be.false
            expect(callback2.called).to.be.true

        it 'should set state to disabled if fetch fails', ->
            callback = sinon.spy()
            expect(snippet.factory.disabled).to.be.false
            snippet.fetch callback()
            expect(@requests.length).to.equal 1

            @requests[0].respond(404, {}, "")

            expect(callback.called).to.be.true
            expect(snippet.factory.disabled).to.be.true

        it 'should set state to disabled if save fails', ->
            actor =
                aid: 1
                type: 'db_user'
                api: 'http://some.api.com'

            snippet.setActor actor

            callback = sinon.spy()
            expect(snippet.factory.disabled).to.be.false

            snippet.save callback()
            expect(@requests.length).to.equal 1

            @requests[0].respond(500, {}, "")

            expect(callback.called).to.be.true
            expect(snippet.factory.disabled).to.be.true

        it 'should block new saves if save is pending', ->
            actor =
                aid: 1
                type: 'db_user'
                api: 'http://some.api.com'

            snippet.setActor actor

            snippet.save()
            snippet.save()
            snippet.save()
            snippet.save()
            snippet.save()

            expect(@requests.length).to.equal 1
            expect(snippet.pending).to.be.true

        it 'should allow new saves after a save finishes', ->
            actor =
                aid: 1
                type: 'db_user'
                api: 'http://some.api.com'

            snippet.setActor actor

            snippet.save()

            @requests[0].respond(200, {}, "[{}]")
            expect(snippet.pending).to.be.false

            snippet.save()

            expect(@requests.length).to.equal 2

        it 'should allow new saves after a save fails', ->
            actor =
                aid: 1
                type: 'db_user'
                api: 'http://some.api.com'

            snippet.setActor actor

            snippet.save()

            @requests[0].respond(500, {}, "")
            expect(snippet.pending).to.be.false

            snippet.save()

            expect(@requests.length).to.equal 2

        it 'firing callbacks should be able to gracefully handle not having callbacks defined', ->
            callback = sinon.spy()
            snippet.fireCallbacks callback()
            expect(callback.called).to.be.true

        it 'should be able to fire a callback', ->
            cbTest = ->
                return 1*1

            callback = sinon.spy()
            snippet.fireCallbacks [cbTest], callback()
            expect(callback.called).to.be.true


    describe 'View Rendering', ->

        it 'should be able to update view given new counts', ->

        it 'should be able to return 0 counts', ->

    describe 'Format Number', ->

        it 'should be able to display formatted number', ->
            expect(snippet.formatNumber('3514', 1, true)).to.equal "3.5k"
            expect(snippet.formatNumber('100', 1, true)).to.equal "100"
            expect(snippet.formatNumber('999999', 1, true)).to.equal "999.9k"
            expect(snippet.formatNumber('1000000', 1, false)).to.equal "1m"
            expect(snippet.formatNumber('9648', 2, false)).to.equal "9.64k"

        it 'should be able to display special caracters', ->
            expect(snippet.formatNumber('314', 1, true)).to.equal "π"
            expect(snippet.formatNumber('2718', 1, true)).to.equal "e"
            expect(snippet.formatNumber('1000000', 1, true)).to.equal "One Milllllllllion"
        
        
