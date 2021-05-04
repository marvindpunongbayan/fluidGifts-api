class ApplicationMailer < ActionMailer::Base
  layout 'mailer'
  default from: "do-not-reply@#{Rails.configuration.env_variables[:domain_name]}"
  default "Message-ID" => proc {"<#{SecureRandom.uuid}@#{Rails.configuration.env_variables[:domain_name]}>"}
  default 'Content-Transfer-Encoding' => '7bit'

  include EmailHelper
  helper EmailHelper
end
