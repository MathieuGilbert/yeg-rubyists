jQuery ->
  class Tweets extends Backbone.Collection
    model: app.Tweet
    url: '/tweets'
    
  
  @app = window.app ? {}
  @app.Tweets = new Tweets