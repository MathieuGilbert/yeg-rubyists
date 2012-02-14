jQuery ->
  class MainRouter extends Backbone.Router
    initialize: () ->
  
    routes:
      "test"    : "test"
      
    index: ->
      

  @app = window.app ? {}
  @app.MainRouter = MainRouter