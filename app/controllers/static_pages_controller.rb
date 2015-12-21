class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @feedbadgeposts = current_user.feed_badgeposts.where("created_at > ?", 30.days.ago).order(created_at: :desc)
    end
  end
end
