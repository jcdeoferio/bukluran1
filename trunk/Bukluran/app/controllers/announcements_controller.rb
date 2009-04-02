class AnnouncementsController < ApplicationController
  def new
    @announcements = Osa.find_by_account_id(session[:user_id]).announcements
  end

  def create
    @announcement = Osa.find_by_account_id(session[:user_id]).announcements.new(params[:announcement])
    if @announcement.save
      redirect_to :controller => 'osas', :action => 'index'
    else
      render :action => 'new'
    end
  end
end
