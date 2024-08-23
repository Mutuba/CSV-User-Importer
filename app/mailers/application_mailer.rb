# frozen_string_literal: true

# ApplicationMailer is the base class for all mailers in the application.
# It sets the default sender email address and specifies the layout to be used
# for email templates.
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
