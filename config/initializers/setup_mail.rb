ActionMailer::Base.smtp_settings = {
#  :address              => "mail.gmx.net",
	:address							=> "smtp.gmail.com",
  :port                 => 587,
#  :domain               => "gmx.de",
  :domain               => "googlemail.com",
  :user_name            => "michi.neiky@googlemail.com",
  :password             => "zcrwanjzrpkaoelj",
  :authentication       => "plain",
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = "localhost:3000"
#Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
