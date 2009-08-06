class EventsController < ApplicationController
  before_filter :login_required
  def index
    @current_user = Organization.find_by_account_id(session[:user_id])
    @events = @current_user.events
    @editable = @current_user.editable
  end
  
  def new
  end
  
  def create
    @current_user = Organization.find_by_account_id(session[:user_id])
    @event = @current_user.events.new(params[:event])
    @editable = @current_user.editable
    
    if @editable
      if @event.save
        redirect_to :action => 'index'
      else
        render :action => 'new'
      end      
    else
      flash[:error] = "Application period is closed or you may have already submitted your application to OSA."
      redirect_to :controller => 'events'
    end
  end
  
  def destroy
    @current_user = Organization.find_by_account_id(session[:user_id])
    @editable = @current_user.editable
    if @editable
      @event = Organization.find_by_account_id(session[:user_id]).events.find(params[:id]).destroy
      flash[:notice] = "Successfully deleted an event"
      redirect_to :controller => 'events'
    else
      flash[:error] = 'Application period is closed or you may have already submitted your application to OSA.'
      redirect_to :action => 'index'
    end
  end
  
end
