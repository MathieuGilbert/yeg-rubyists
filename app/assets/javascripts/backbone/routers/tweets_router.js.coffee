class YegRubyists.Routers.TweetsRouter extends Backbone.Router
  initialize: (options) ->
    @tweets = new YegRubyists.Collections.TweetsCollection(options)
    @tweets.reset options.tweets

  routes:
    "/index"    : "index"
    ".*"        : "index"

  index: ->
    @view = new YegRubyists.Views.Tweets.IndexView(tweets: @tweets)
    $("#twitter").html(@view.render().el)

