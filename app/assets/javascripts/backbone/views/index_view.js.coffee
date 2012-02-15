YegRubyists.Views.Tweets ||= {}

class YegRubyists.Views.Tweets.IndexView extends Backbone.View
  template: JST["backbone/templates/tweets/index"]

  initialize: () ->
    @options.tweets.bind('reset', @addAll)

  addAll: () =>
    @options.tweets.each(@addOne)

  addOne: (tweet) =>
    view = new YegRubyists.Views.Tweets.TweetView({model : tweet})
    @$("ul").append(view.render().el)

  render: =>
    $(@el).html(@template(tweets: @options.tweets.toJSON() ))
    @addAll()

    return this
