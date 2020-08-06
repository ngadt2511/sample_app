class ApplicationMailer < ActionMailer::Base
  default from: ENV["NOREPLY_EXAMPLE"]
  layout "mailer"
end
