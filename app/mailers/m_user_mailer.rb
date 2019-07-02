class MUserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.m_user_mailer.account_activation.subject
  #
  def account_activation(muser)
    @muser = muser
    mail to: muser.email, subject: "Account activation"
  end


  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.m_user_mailer.password_reset.subject
  #
  def password_reset
    @greeting = "Hi"

    mail to: "to@gmail.com"
  end
end
