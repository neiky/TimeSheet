ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "googlemail.com",
  :user_name            => "michi.neiky@googlemail.com",
  :password             => "zcrwanjzrpkaoelj",
  :authentication       => "plain",
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = "localhost:3000" if !Rails.env.production?
ActionMailer::Base.default_url_options[:host] = "localhost/timerecorder" if Rails.env.production?