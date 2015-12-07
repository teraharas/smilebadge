class ApplicationMailer < ActionMailer::Base
  default from: ENV["FROM_MAIL_ADDRESS"]
  layout 'mailer'
end
