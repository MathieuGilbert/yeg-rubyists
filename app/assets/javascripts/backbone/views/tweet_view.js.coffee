jQuery ->
  class TweetView extends Backbone.View
    el:$('#twitter')
    template: JST["backbone/templates/tweet"]
    
    initialize: () ->
      
    render: ->
      $(@el).append(@template(@model.toJSON()))
      @
      

  @app = window.app ? {}
  @app.TweetView = TweetView