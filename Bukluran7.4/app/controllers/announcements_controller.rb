class AnnouncementsController < ApplicationController
  before_filter :login_required
  def new
  end

  def create
    @announcement = Osa.find_by_account_id(session[:user_id]).announcements.new(params[:announcement])
    if @announcement.save
      @orgmails = email_list
      Notifier.deliver_announcement_mail(@announcement, @orgmails)
      flash[:notice] = "Emails have been sent"
      redirect_to :controller => 'osas', :action => 'index'
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @announcement = Osa.find_by_account_id(session[:user_id]).announcements.find(params[:id]).destroy
    redirect_to :controller => 'osas'
  end
  
  def email_list
    @orgmails = Organization.find_by_sql("SELECT email_org FROM Organizations")
    #returns an array of hashes to email_org... pede na rin manipulate
    @list = []
    for x in @orgmails
       @list.concat([x.email_org])
    end
    return @list
  end
end