jQuery ->
  class MainView extends Backbone.View
    
    initialize: () ->
      app.Tweets.bind('add', @addOneTweet, this);
      app.Tweets.bind('reset', @addAllTweets, this);
      
    addOneTweet: (tweet) ->
      tweetView = new app.TweetView({model: tweet})
      $("#twitter").prepend(tweetView.render().el)
    
    addAllTweets: ->
      app.Tweets.each(@addOneTweet)
      
  @app = window.app ? {}
  @app.MainView = new MainView