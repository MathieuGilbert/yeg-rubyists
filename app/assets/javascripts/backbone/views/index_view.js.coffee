app.Views.Tweets ||= {}
app.Views.GitEvents ||= {}

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

class app.Views.GitEvents.IndexView extends Backbone.View
  template: JST["backbone/templates/git_events/index"]

  initialize: () ->
    @options.git_events.bind('add', @addOne);
    @options.git_events.bind('reset', @addAll)

  addAll: () =>
    @options.git_events.each(@addOne)

  addOne: (git_event) =>
    view = new app.Views.GitEvents.GitEventView({model : git_event})
    @$("ul").prepend(view.render().el)

  render: =>
    $(@el).html(@template(tweets: @options.git_events.toJSON() ))
    @addAll()

    return this
