jQuery ->
  class Tweet extends Backbone.Model
    #url: '/tweets/#{@id}'
          
  @app = window.app ? {}
  @app.Tweet = Tweet