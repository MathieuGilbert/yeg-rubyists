app.Views.Tweets ||= {}

class app.Views.Tweets.TweetView extends Backbone.View
  template: JST["backbone/templates/tweets/tweet"]

  render: ->
    $(@el).html(@member_partial(@model) + @template(@model.toJSON()))
    return @

  member_partial: (model) ->
    member_view = new app.Views.Members.MemberView({model: model.get("twitter_member")})
    member_view.render().el.innerHTML