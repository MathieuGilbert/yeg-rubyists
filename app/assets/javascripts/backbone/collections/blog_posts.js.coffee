class app.Collections.BlogPostsCollection extends Backbone.Collection
  model: app.Models.BlogPost

  url: ->
    "/blog_posts?date=" + @models[@models.length-1].get("date")
    
  comparator: (blog_post) ->
    blog_post.get('date')