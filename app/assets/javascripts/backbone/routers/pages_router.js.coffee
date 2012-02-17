class app.Routers.PagesRouter extends Backbone.Router
  initialize: (options) ->
    @tweets = new app.Collections.TweetsCollection()
    @tweets.reset(options.tweets)
    
    @git_events = new app.Collections.GitEventsCollection()
    @git_events.reset(options.git_events)
    
    @blog_posts = new app.Collections.BlogPostsCollection()
    @blog_posts.reset(options.blog_posts)

  routes:
    "/index"    : "index"
    ".*"        : "index"

  index: ->
    tweet_view = new app.Views.Tweets.IndexView(tweets: @tweets)
    $("#twitter").html(tweet_view.render().el)
    
    git_event_view = new app.Views.GitEvents.IndexView(git_events: @git_events)
    $("#github").html(git_event_view.render().el)

    blog_post_view = new app.Views.BlogPosts.IndexView(blog_posts: @blog_posts)
    $("#blogrss").html(blog_post_view.render().el)
