describe 'Unit Testing Activity Stream Factory:', ->

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
      divs = document.querySelectorAll('.activitysnippet')
      for own key, value of divs
        unless key is 'length'
            if value.getAttribute('data-id')? then value.removeAttribute('data-id')
            value.innerHTML = ''

    describe 'Initialization', ->
        it 'should not be able to initialize without the service endpoint', ->
            errorMaker= ->
                new ActivitySnippet.ActivityStreamSnippetFactory()
            expect(errorMaker).to.throw(Error, 'SnippetFactory:: Must pass in ActivityStreamAPI')

        it 'should have some internal defaults', ->
            obj=
                ActivityStreamAPI: 'http://as.dev.nationalgeographic.com:9364/api/v1'
            snippetFactory = new ActivitySnippet.ActivityStreamSnippetFactory(obj)
            snippetFactory.settings.should.have.property('debug')
            expect(snippetFactory.settings.debug).to.be.false

        it 'should allow for overriding the internal defaults by accepting config', ->
            options.debug = true
            snippetFactory = new ActivitySnippet.ActivityStreamSnippetFactory(options)
            snippetFactory.settings.should.have.property('debug')
            expect(snippetFactory.settings.debug).to.be.true

        it 'should be able to find the amount of snippets on the page', ->
            # currently index.html contains snippet elements
            snippetFactory = new ActivitySnippet.ActivityStreamSnippetFactory(options)
            count = document.querySelectorAll('.activitysnippet').length
            assert snippetFactory.snippets.length == count, 'Amount of snippets on the page did not matched the collection length: ' + count + ' != ' + snippetFactory.snippets.length

        it 'should instantiate ActivityStreamSnippet objects for every element on the page', ->
            snippetFactory = new ActivitySnippet.ActivityStreamSnippetFactory(options)
            count = document.querySelectorAll('.activitysnippet').length
            for i of snippetFactory.snippets
                assert snippetFactory.snippets[i] instanceof ActivitySnippet.ActivityStreamSnippet, 'Snippets not of type ActivityStreamSnippet, something went wrong with initialization'
            i++
            assert i == count, 'Number of instantiated snippets did not match number of elements on page'

        it 'should give an id to every snippet on the page', ->
            snippetFactory = new ActivitySnippet.ActivityStreamSnippetFactory(options)
            elements = document.querySelectorAll('.activitysnippet')
            for own key, value of elements
                unless key is 'length'
                    assert value.getAttribute('data-id')?, 'Not all the snippets on the page got an id'

    describe 'Handle lazy loading of snippets', ->                
        it 'should be able to find new elements on the page when refresh is called', ->
            snippetFactory = new ActivitySnippet.ActivityStreamSnippetFactory(options)
            x = document.createElement 'div'
            x.setAttribute('data-verb','favorited')
            x.classList.add('activitysnippet')
            snippetFactory.refresh()
            count = document.querySelectorAll('.activitysnippet').length
            assert snippetFactory.snippets.length == count, 'Amount of snippets on the page did not matched the collection length: ' + count + ' != ' + snippetFactory.snippets.length

    describe 'State Management', ->
        it 'should allow to toggle state', ->
            snippetFactory = new ActivitySnippet.ActivityStreamSnippetFactory(options)
            assert snippetFactory.active, 'Snippet is not active as default'
            snippetFactory.toggleState()
            assert !snippetFactory.active, 'Snippet was not toggled to be inactive'
            snippetFactory.toggleState()
            assert snippetFactory.active, 'Snippet is not back to being active'

        it 'should switch snippet(s) state on factory toggle', ->
            snippetFactory = new ActivitySnippet.ActivityStreamSnippetFactory(options)
            stateMatch= ->
                for i of snippetFactory.snippets
                    assert snippetFactory.active == snippetFactory.snippets[i].active, 'Individual snippet doesn\'t match parent state'
            stateMatch()
            snippetFactory.toggleState()
            stateMatch()
            snippetFactory.toggleState()
            stateMatch()

    describe 'Actor Management', ->
        it 'should allow setting a different actor', ->
            diffActor =
                id: 2
                type: 'mmdb_user'
                api: 'http://mmdb.dev.nationalgeographic.com:8000/api/v1/user/2/'
            snippetFactory = new ActivitySnippet.ActivityStreamSnippetFactory(options)
            snippetFactory.setActor diffActor
            assert snippetFactory.actor == diffActor, 'the actor sets did not change'

        it 'should set the new actor on all the snippets', ->
            diffActor =
                id: 2
                type: 'mmdb_user'
                api: 'http://mmdb.dev.nationalgeographic.com:8000/api/v1/user/2/'
            snippetFactory = new ActivitySnippet.ActivityStreamSnippetFactory(options)
            snippetFactory.setActor diffActor
            assert snippetFactory.snippets[0].actor == diffActor, 'the actor sets did not change'