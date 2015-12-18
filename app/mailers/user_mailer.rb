class UserMailer < ApplicationMailer
  default from: ENV["FROM_MAIL_ADDRESS"]
  
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "SMILE Badgeパスワードリセット"
  end
end