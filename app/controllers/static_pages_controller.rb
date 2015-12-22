class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @feedbadgeposts = Badgepost.limit(10).where(recept_user_id: current_user.id).where("created_at > ?", 30.days.ago).order(created_at: :desc)
    end
  end
end
