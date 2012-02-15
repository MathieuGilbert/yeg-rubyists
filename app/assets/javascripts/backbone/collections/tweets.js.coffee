class app.Collections.TweetsCollection extends Backbone.Collection
  model: app.Models.Tweet

  url: ->
    "/tweets?date=" + @models[@models.length-1].get("date")
    
  comparator: (tweet) ->
    tweet.get('date')