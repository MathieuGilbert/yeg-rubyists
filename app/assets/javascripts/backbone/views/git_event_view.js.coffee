app.Views.GitEvents ||= {}

class app.Views.GitEvents.GitEventView extends Backbone.View
  template: JST["backbone/templates/git_events/git_event"]

  tagName: "li"

  render: ->
    $(@el).html(@template(@model.toJSON()))
    return @