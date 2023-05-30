if Rails.env.production?
  ActionMailer::Base.smtp_settings = {
    address: 'smtp.sendgrid.net',
    port: 587,
    domain: 'sac-controller.herokuapp.com',
    user_name: ENV['SENDGRID_USERNAME'],
    password: ENV['SENDGRID_PASSWORD'],
    authentidation: :login,
    enable_starttls_auto: true
  }
end
