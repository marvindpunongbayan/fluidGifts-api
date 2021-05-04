class SessionsMailer < ApplicationMailer
  def forgot_password(user, token)
    @user = user
    @token = token
    subject = "Your reset password link"
    send_mail(to: user.email, subject: subject)
  end
end
