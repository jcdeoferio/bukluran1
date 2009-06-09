class Notifier < ActionMailer::Base
  def welcome_email(email,subj,password,username)  
    recipients email 
    from "Office of Student Activities <up.bukluran@gmail.com>"  
    subject subj  
    sent_on Time.now 
    body :password => password, :username => username 
  end 
  
  def confirm_member(student, org)
    recipients student.webmail
    from "Office of Student Activities <up.bukluran@gmail.com>"  
    subject 'MEMBERSHIP CONFIRMATION'
    sent_on Time.now 
    body :org => org, :student => student
  end
  
  def announcement_mail(announcement, orgmails)
    recipients orgmails
    from "Office of Student Activities <up.bukluran@gmail.com>"  
    subject 'ANNOUNCEMENT'
    sent_on Time.now 
    body :announcement => announcement
  end
end
