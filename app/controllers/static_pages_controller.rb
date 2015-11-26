class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @badgepost = current_user.sent_badgeposts.build
      
      # フィード
      @feed_items = current_user.feed_items.order(created_at: :desc)
    end
  end
end
