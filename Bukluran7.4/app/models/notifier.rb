class Notifier < ActionMailer::Base
  def welcome_email(email,subj,password,username)  
    recipients email 
    from "Office of Student Activities <up.bukluran@gmail.com>"  
    subject subj  
    sent_on Time.now 
    body :password => password, :username => username 
  end 
  
  def confirm_member(member, org)
    recipients member.student.webmail
    from "Office of Student Activities <up.bukluran@gmail.com>"  
    subject 'MEMBERSHIP CONFIRMATION'
    sent_on Time.now 
    body :org => org, :member => member
  end
  
end
