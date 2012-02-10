jQuery ->
  class MainRouter extends Backbone.Router
    initialize: () ->
  
    routes:
      "/index"    : "index"
      ".*"        : "index"
      
    index: ->
      

  @app = window.app ? {}
  @app.MainRouter = MainRouter