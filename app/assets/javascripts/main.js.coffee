# This is the start point
@app = window.app ? {}

jQuery ->
  # Refresh incoming twitter posts
  setInterval( ->
    app.Tweets.fetch()
  , 1000)
