class NoticeMailer < ApplicationMailer
  
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notice_mailer.hello.subject
  #
  def mail_recept_badge(badgepost)
    @recept_user_name = badgepost.recept_user.name
    # binding.pry
    # mail to: badgepost.recept_user.email
    mail to: badgepost.recept_user.email, subject: badgepost.recept_user.name + "さんにバッジが届きました！！"
  end
end
