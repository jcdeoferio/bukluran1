class Notifier < ActionMailer::Base
  def sendmail(recipient)
    recipients recipient.webmail
    cc ["woosh_lee@yahoo.com"]
    from       "system@bukluran.com"
    subject    "Membership confirmation"
    body       :student => recipient
  end
  

end
