class app.Routers.TweetsRouter extends Backbone.Router
  initialize: (options) ->
    @tweets = new app.Collections.TweetsCollection()
    @tweets.reset(options.tweets)

  routes:
    "/index"    : "index"
    ".*"        : "index"

  index: ->
    @view = new app.Views.Tweets.IndexView(tweets: @tweets)
    $("#twitter").html(@view.render().el)

