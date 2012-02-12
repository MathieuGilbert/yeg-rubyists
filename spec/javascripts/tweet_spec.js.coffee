app = window.app ? {}

describe "Tweet", ->

  describe "new tweet", ->
    beforeEach ->
      @tweet = new app.Tweet
        username: 'ryanonrails'

    it "should not have a null username", ->
      expect(@tweet.get('username')).toEqual 'ryanonrails'