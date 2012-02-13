app = window.app ? {}

describe "Tweet", ->

  describe "when instantiated", ->
    beforeEach ->
      @tweet = new app.Tweet
        content: 'I like pie!'

    it "should exhibit attributes", ->
      expect(@tweet.get('content')).toEqual 'I like pie!'
      
#  describe "url", ->
#    beforeEach ->
#      @tweets = new app.TweetsTest
#      
#    describe "when no id is set", ->
#      it "should return the collection URL", ->
#        expect(@tweets.url()).toEqual("/tweets")

