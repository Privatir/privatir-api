class ApplicationMailer < ActionMailer::Base
  default from: 'cameron.rison@gmail.com'

  def welcome_email
    @email = params[:email]
    mail(to: @email, subject: 'Welcome to My Awesome Site')
  end
end
