describe 'Unit Testing of Activty Stream Snippet', ->


    describe 'Instantization', ->

        it 'should take a node list and handlebar tempalte', ->

        it 'should throw excpetion when element is not passed in', ->

            snippet = () ->
                new ActivitySnippet.ActivityStreamSnippet()
            expect(snippet).to.throw(/Need Html Element/)








