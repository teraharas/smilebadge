class StaticPagesController < ApplicationController
  def home
    if logged_in?
      # フィード
      @feedbadgeposts = current_user.feed_badgeposts.order(created_at: :desc)
    end
  end
end
