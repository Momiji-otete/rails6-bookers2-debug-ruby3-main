class UserMailer < ApplicationMailer

  def send_email(title, body, users)
    @email_title = title
    @email_body = body

    mail(bcc: users.pluck(:email), subject: @email_title)
  end
end
