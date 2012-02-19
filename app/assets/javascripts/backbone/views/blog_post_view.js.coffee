app.Views.BlogPosts ||= {}

class app.Views.BlogPosts.BlogPostView extends Backbone.View
  template: JST["backbone/templates/blog_posts/blog_post"]

  render: ->
    $(@el).html(@member_partial(@model) + @template(@model.toJSON()))
    return @

  member_partial: (model) ->
    member_view = new app.Views.Members.MemberView({model: model.get("blog_member")})
    member_view.render().el.innerHTML