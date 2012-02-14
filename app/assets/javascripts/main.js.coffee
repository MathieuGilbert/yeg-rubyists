# This is the start point
@app = window.app ? {}

jQuery ->
  app_router = new app.MainRouter
  Backbone.history.start()
  
  #Refresh incoming twitter posts
  # setInterval( ->
    # app.Tweets.fetch({add: true})
  # , 2000)
