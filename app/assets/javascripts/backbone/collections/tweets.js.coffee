class YegRubyists.Collections.TweetsCollection extends Backbone.Collection
  model: YegRubyists.Models.Tweet
  
  initialize: (options) ->
    url: "/tweets?date=" + options.tweets[options.tweets.length-1].date
    
  comparator: (tweet) ->
    tweet.get('date')

