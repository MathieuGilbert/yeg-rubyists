class app.Collections.MembersCollection extends Backbone.Collection
  model: app.Models.Member

  url: ->
    "/members"
