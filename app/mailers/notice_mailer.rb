class NoticeMailer < ApplicationMailer
  
  default from: ENV["FROM_MAIL_ADDRESS"]

  def mail_recept_badge(badgepost)
    @recept_user_name = badgepost.recept_user.name
    mail to: badgepost.recept_user.email, subject: badgepost.recept_user.name + "さんにバッジが届きました！！"
  end
end
