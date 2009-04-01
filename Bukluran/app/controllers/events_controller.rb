class EventsController < ApplicationController
  def index
    @events = Organization.find_by_account_id(session[:user_id]).events
  end
  
  def new
    @events = Organization.find_by_account_id(session[:user_id]).events
  end
  
  def create
    @event = Organization.find_by_account_id(session[:user_id]).events.new(params[:event])
    
    if @event.save
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end      
  end
  
  def show
    @event = Organization.find_by_account_id(session[:user_id]).events.find(params[:id])
  end
  
  def edit
    @event = Organization.find_by_account_id(session[:user_id]).events.find(params[:id])
  end
  
  def report
    @event = Organization.find_by_account_id(session[:user_id]).events.find(params[:id])
  end
  
  def update
    @event = Organization.find_by_account_id(session[:user_id]).events.find(session[:event_id])
    if @event.update_attribute('report', params[:event][:report])
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end
end
