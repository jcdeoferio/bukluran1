class AnnouncementsController < ApplicationController
  before_filter :login_required
  def new
  end

  def create
    @announcement = Osa.find_by_account_id(session[:user_id]).announcements.new(params[:announcement])
    if @announcement.save
      redirect_to :controller => 'osas', :action => 'index'
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @announcement = Osa.find_by_account_id(session[:user_id]).announcements.find(params[:id]).destroy
    redirect_to :controller => 'osas'
  end
  
end
