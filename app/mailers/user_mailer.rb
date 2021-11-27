class UserMailer < ApplicationMailer
  def send_event_mail(users, title, content)
    users = users
    mail bcc: users.map{|u|u.mail}
    mail subject: title
    @content = content
  end
end
