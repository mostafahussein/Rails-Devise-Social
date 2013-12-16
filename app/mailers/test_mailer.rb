class TestMailer < ActionMailer::Base
  default :from => "support@comparendo.ch"
  default :to => "support@comparendo.ch"

  def contact_mail(from, to)
     load_settings
     mail(:from => from, :to => to, :subject => "[Comparendo Test Request] ") do |f|
       f.html { render text: "This is a test email for testing act
mailer"}
     end
  end
  
  private
    def load_settings
      @@smtp_settings = {
        address: "localhost",
	port: 25,
	domain: "comparendo.ch",
        authentication: :plain,
	user_name: "comparendo",
	password: "washuchan",
	enable_starttls_auto: true
      }
      self.smtp_settings.merge!(@@smtp_settings)
    end
end