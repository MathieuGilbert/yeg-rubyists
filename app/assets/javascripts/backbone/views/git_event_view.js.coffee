app.Views.GitEvents ||= {}

class app.Views.GitEvents.GitEventView extends Backbone.View
  template: JST["backbone/templates/git_events/git_event"]

  render: ->
    $(@el).html(@template(@model.toJSON()))
    return @

  member_partial: (model) ->
    member_view = new app.Views.Members.MemberView({model: model.get("github_member")})
    member_view.render().el.innerHTML