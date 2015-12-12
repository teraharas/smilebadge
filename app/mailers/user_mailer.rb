class UserMailer < ActionMailer::Base
  def password_reset(user)
    token = Rails.application.message_verifier(:password_reset).generate([user.id, 1.day.since])
    mail(to: user.email, body: edit_password_reset_url(token))
  end
end