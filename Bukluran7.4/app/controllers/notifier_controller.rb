class NotifierController < ApplicationController
	def index
	end
	def get_password
		@organization = Organization.find_by_account_id(Account.find_by_username(params[:username]))
		if @organization == nil
		  flash[:error] = "Username does not exist"
	    elsif @organization.email_head == nil
	      flash[:error] = "Email of Organization Head not found"
	    else
		  @password = @organization.account.password
		  @subject = 'PASSWORD REQUEST'
		  Notifier.deliver_welcome_email(@organization.email_head,@subject,@password,params[:username])
		  flash[:notice] = "Mail was successfully sent to organization's head email account"
		end
		redirect_to :controller => 'main', :action => 'index'
	end
	
	def get_confirmation
	   @org = Organization.find_by_id(params[:id])
	   for @member in @org.members
	     @member.confirmation_key = conkey
	     @member.save
	     Notifier.deliver_confirm_member(@member, @org)
	   end
	   redirect_to "/osas/show_forms/#{@org.id}"
	end
	
	def confirm
	 @member = Member.find_by_confirmation_key(params[:id])
	 @member.confirm = true
	 @member.save
	end
	
	def conkey
	 @key = @org.name.crypt "#{@member.id}pLeNMirfmconFrimmd123nf3fh321dfrgFMJSD#{Time.now.sec}"
	 @key.gsub("/", "!")
	 return @key
	end
	
end