app = window.app ? {}

describe "Tweet", ->

  describe "when instantiated", ->
    beforeEach ->
      @tweet = new app.Tweet
        username: 'ryanonrails'

    it "should exhibit attributes", ->
      expect(@tweet.get('username')).toEqual 'ryanonrails'