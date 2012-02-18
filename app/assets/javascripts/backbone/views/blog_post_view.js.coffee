app.Views.BlogPosts ||= {}

class app.Views.BlogPosts.BlogPostView extends Backbone.View
  template: JST["backbone/templates/blog_posts/blog_post"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
