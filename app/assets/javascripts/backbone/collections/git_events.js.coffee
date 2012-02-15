class app.Collections.GitEventsCollection extends Backbone.Collection
  model: app.Models.GitEvent

  url: ->
    "/git_events?date=" + @models[@models.length-1].get("date")
    
  comparator: (git_event) ->
    git_event.get('date')