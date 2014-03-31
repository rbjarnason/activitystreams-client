describe 'Unit Testing Activity Stream Events:', ->
    cat = dog = null

    beforeEach ->
        cat = new ActivitySnippet.Events()
        dog = new ActivitySnippet.Events()

    afterEach ->
        cat.off()
        cat.stopListening
        dog.off()
        dog.stopListening()

    describe 'listenTo()', ->
        it 'should return listening object', ->
            assert.deepEqual cat.listenTo(dog, 'bark', -> return 'meow'), cat

        it 'should run callback after trigger', ->
            cat.listenTo dog, 'bark', -> this.sound = 'meow'
            dog.trigger 'bark'
            assert.equal cat.sound, 'meow'

        it 'should only listen to events on specified channel', ->
            cat.count = 0
            cat.listenTo dog, 'bark', -> this.count++
            cat.listenTo dog, 'quack', -> this.count++
            dog.trigger 'bark'
            dog.trigger 'moo'
            assert.equal cat.count, 1

        it 'should only listen to events on specified object', ->
            cat.count = 0
            cat.listenTo dog, 'bark', -> this.count++
            dog.trigger 'bark'
            cat.trigger 'meow'
            assert.equal cat.count, 1

        it 'should listen to all events if channel is *', ->
            cat.count = 0
            cat.listenTo dog, '*', -> this.count++
            dog.trigger 'bark'
            dog.trigger 'moo'
            assert.equal cat.count, 2

        it 'should bind callback to correct `this`', ->
            cat.listenTo dog, 'bark', ->
                assert.deepEqual this, cat
                assert.notEqual this, dog
            dog.trigger 'bark'

    describe 'on()', ->
        it 'should return listening object', ->
            assert.deepEqual dog.on('sound', -> return 'bark'), dog

        it 'should run callback after trigger', ->
            dog.on 'sound', -> this.sound = 'bark'
            dog.trigger 'sound'
            assert.equal dog.sound, 'bark'

        it 'should only listen to events on specified channel', ->
            dog.count = 0
            dog.on 'bark', -> this.count++
            dog.on 'quack', -> this.count++
            dog.trigger 'bark'
            dog.trigger 'moo'
            assert.equal dog.count, 1

        it 'should listen to all events if channel is *', ->
            dog.count = 0
            dog.on '*', -> this.count++
            dog.trigger 'bark'
            dog.trigger 'moo'
            assert.equal dog.count, 2

        it 'should bind callback to correct `this`', ->
            dog.on 'bark', -> assert.deepEqual this, dog
            dog.trigger 'bark'
            dog.on 'woof', ->
                assert.deepEqual this, cat
            , cat
            dog.trigger 'cat'

    describe 'stopListening()', ->
        it 'should return listening object', ->
            assert.deepEqual cat.stopListening(), cat

        it 'should stop unsubscribe from all events if no params are given', ->
            cat.count = 0
            cat.listenTo dog, 'bark', -> this.count++
            dog.trigger 'bark'
            assert.equal cat.count, 1
            cat.stopListening()
            dog.trigger 'bark'
            assert.equal cat.count, 1

        it 'should only unsubscribe from events on matching object', ->
            cat.count = 0
            cat.listenTo dog, 'bark', -> this.count++
            cat.stopListening cat
            dog.trigger 'bark'
            assert.equal cat.count, 1
            cat.stopListening dog
            dog.trigger 'bark'
            assert.equal cat.count, 1

        it 'should only unsubscribe from events with matching channel', ->
            cat.count = 0
            cat.listenTo dog, 'bark', -> this.count++
            cat.stopListening dog, 'woof'
            dog.trigger 'bark'
            assert.equal cat.count, 1

        it 'should only unsubscribe from events with matching callback', ->
            cat.count = 0
            callback = -> this.count++
            callback2 = -> this.count = this.count + 1
            cat.listenTo dog, 'bark', callback
            cat.stopListening dog, 'bark', callback2
            cat.stopListening dog, undefined, callback2
            dog.trigger 'bark'
            assert.equal cat.count, 1
            cat.stopListening dog, undefined, callback
            dog.trigger 'bark'
            assert.equal cat.count, 1

    describe 'off()', ->
        it 'should return listening object', ->
            assert.deepEqual dog.off(), dog

        it 'should stop unsubscribe from all events if no params are given', ->
            dog.count = 0
            dog.on 'bark', -> this.count++
            dog.trigger 'bark'
            assert.equal dog.count, 1
            dog.off()
            dog.trigger 'bark'
            assert.equal dog.count, 1

        it 'should only unsubscribe from events with matching channel', ->
            dog.count = 0
            dog.on 'bark', -> this.count++
            dog.off 'woof'
            dog.trigger 'bark'
            assert.equal dog.count, 1

        it 'should only unsubscribe from events with matching callback', ->
            dog.count = 0
            callback = -> this.count++
            callback2 = -> this.count = this.count + 1
            dog.on 'bark', callback
            dog.off 'bark', callback2
            dog.off undefined, callback2
            dog.trigger 'bark'
            assert.equal dog.count, 1
            dog.off undefined, callback
            dog.trigger 'bark'
            assert.equal dog.count, 1

        it 'should only unsubscribe from events with matching context', ->
            cat.count = 0
            callback = -> this.count++
            dog.on 'bark', callback , cat
            dog.off 'bark', undefined, dog
            dog.off undefined, undefined, dog
            dog.off 'bark', callback, dog
            dog.off undefined, callback, dog
            dog.trigger 'bark'
            assert.equal cat.count, 1
            dog.off undefined, undefined, cat
            dog.trigger 'bark'
            assert.equal cat.count, 1

    describe 'trigger', ->

        it 'should pass custom argument as first param', ->
            dog.on 'name', (name) -> dog.name = name
            dog.trigger 'name', 'Paul'
            assert.equal dog.name, 'Paul'

        it 'should pass channel name as second param', ->
            dog.on 'NPR', (name, channel) -> assert.equal channel, 'NPR'
            dog.trigger 'NPR'
