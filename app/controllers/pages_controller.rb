class PagesController < ApplicationController
  def index
    # Get the most recent 25 tweets
    @tweets = filter(Tweet)
    @git_events = filter(GitEvent)
    @blog_posts = filter(BlogPost)
  end

  private
    def approved_member_ids
      Member.where(:status => 'approved').map(&:id).join(", ")
    end

    def filter(model)
      model.where("member_id IN (#{approved_member_ids})").order("date desc").limit(25)
    end
end
