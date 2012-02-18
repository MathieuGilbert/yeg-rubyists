# start
jQuery ->
  #Refresh incoming twitter posts
  setInterval( ->
    router.tweets.fetch({add: true})
    router.blog_posts.fetch({add: true})
  , 10000)
