app.Views.Tweets ||= {}

class app.Views.Tweets.TweetView extends Backbone.View
  template: JST["backbone/templates/tweets/tweet"]

  tagName: "li"

  render: ->
    tweet_partial = @template(@model.toJSON())
    $(@el).html(@member_partial(@model) + tweet_partial)
    return @

  member_partial: (model) ->
    member_view = new app.Views.Members.MemberView({model: model.get("twitter_member")})
    member_view.render().el.innerHTML