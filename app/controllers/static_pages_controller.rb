class StaticPagesController < ApplicationController
  def home
    if logged_in?
      # @badgepost = current_user.sent_badgeposts.build
      # フィード
      @feedbadgeposts = current_user.feed_badgeposts.order(created_at: :desc)
    end
  end
end
