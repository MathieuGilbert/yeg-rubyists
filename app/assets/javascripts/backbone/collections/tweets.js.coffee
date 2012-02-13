jQuery ->
  class Tweets extends Backbone.Collection
    model: app.Tweet
    
    initialize: () ->
      @bind('add', @addOneTweet, this);
      @bind('reset', @addAllTweets, this);
    
    # Once the initial dataset is loaded via reset (on page load)
    #  the url will get the tweets after the initial load
    url: ->
      "/tweets?date=" + @models[@models.length-1].get("date")
      
    # Sorting function, if you don't have this, the models will be added will-nilly
    comparator: (tweet)->
      tweet.get('date')
      
    addOneTweet: (tweet) ->
      tweetView = new app.TweetView({model: tweet})
      $("#twitter").prepend(tweetView.render().el)
    
    addAllTweets: ->
      @each(@addOneTweet)
  
  @app = window.app ? {}
  @app.Tweets = new Tweets
