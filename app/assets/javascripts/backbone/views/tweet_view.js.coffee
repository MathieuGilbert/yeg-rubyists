jQuery ->
  class TweetView extends Backbone.View
    tagName: "div"
    id: "tweet"
    template: JST["backbone/templates/tweet"]
    
    initialize: () ->

    render: ->
      $(@el).html(@template(@model.toJSON()));
      @
      
  @app = window.app ? {}
  @app.TweetView = TweetView