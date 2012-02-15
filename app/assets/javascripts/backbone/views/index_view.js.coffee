app.Views.Tweets ||= {}

class app.Views.Tweets.IndexView extends Backbone.View
  template: JST["backbone/templates/tweets/index"]

  initialize: () ->
    @options.tweets.bind('add', @addOne);
    @options.tweets.bind('reset', @addAll)

  addAll: () =>
    @options.tweets.each(@addOne)

  addOne: (tweet) =>
    view = new app.Views.Tweets.TweetView({model : tweet})
    @$("ul").prepend(view.render().el)

  render: =>
    $(@el).html(@template(tweets: @options.tweets.toJSON() ))
    @addAll()

    return this
