jQuery ->
  class Tweets extends Backbone.Collection
    model: app.Tweet
    
    url: ->
      "/tweets?date=" + @models[@models.length-1].get("date")
      
    comparator: (tweet)->
      tweet.get('date')
  
  @app = window.app ? {}
  @app.Tweets = new Tweets