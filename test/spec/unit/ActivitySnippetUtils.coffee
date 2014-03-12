describe 'Unit Testing Activity Stream Utils:', ->
  describe 'unpack()', ->
    
    it 'should return an array', ->
      arr = ActivitySnippet.utils.unpack([], [1,2,3]);
      assert.isArray arr, 'did not return an array'
    

    it 'should return an array of [1,2,3] from input [1,2,3]', ->
      arr = ActivitySnippet.utils.unpack([], [1,2,3]);
      assert.isArray arr, 'did not return an array'
      assert.lengthOf arr, 3, 'did not flatten the array'

    it 'should accept a non-array as a parameter', ->
      arr = ActivitySnippet.utils.unpack([], -> console.log('test'); )
      assert.isArray arr, 'did not return an array'
      assert.lengthOf arr, 1, 'did not unpack the paramter into the array'
      assert.equal typeof arr[0], 'function', 'converted the type of the input'