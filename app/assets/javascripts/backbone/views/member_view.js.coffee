app.Views.Members ||= {}

class app.Views.Members.MemberView extends Backbone.View
  template: JST["backbone/templates/members/member"]

  render: ->
    $(@el).html(@template(@model))
    return this
