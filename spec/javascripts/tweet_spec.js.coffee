app = window.app ? {}

describe "Tweet", ->

  describe "when instantiated", ->
    beforeEach ->
      @tweet = new app.Tweet
        username: 'ryanonrails'

    it "should exhibit attributes", ->
      expect(@tweet.get('username')).toEqual('ryanonrails')
      
#  describe "url", ->
#    beforeEach ->
#      @tweets = new app.TweetsTest
#      
#    describe "when no id is set", ->
#      it "should return the collection URL", ->
#        expect(@tweets.url()).toEqual("/tweets")


      
      
      
      
      
      
      
      