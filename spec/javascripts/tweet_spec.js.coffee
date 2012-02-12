app = window.app ? {}

describe "Tweet", ->

  describe "when instantiated", ->
    beforeEach ->
      @tweet = new app.Tweet
        content: 'I like pie!'

    it "should exhibit attributes", ->
      expect(@tweet.get('content')).toEqual 'I like pie!'