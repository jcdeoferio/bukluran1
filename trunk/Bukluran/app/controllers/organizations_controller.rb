class OrganizationsController < ApplicationController
  def index
    @data = Organization.find_by_account_id(session[:user_id])
    @announcements = Announcement.find(:all)
    
    case @data.status
      when -1
        flash[:notice] = "Not Renewed"
      when 0
        flash[:notice] = "Application Pending"
      when 1
        flash[:notice] = "Renewed"
    end
    
  end
  
  def show
     @data = Organization.find_by_account_id(session[:user_id])
  end
  
  def update
    @data = Organization.find_by_account_id(session[:user_id])
    
    if @data.update_attributes(params[:data])
      redirect_to :action => 'show'
    else
      render :action => session[:from_form]
    end
  end
  
  def form1
    @data = Organization.find_by_account_id(session[:user_id])
  end
  
  def form2
    @data = Organization.find_by_account_id(session[:user_id])
  end
  
  def form7
    @data = Organization.find_by_account_id(session[:user_id])
  end
  
  def submit
     @data = Organization.find_by_account_id(session[:user_id])
    
    if @data.update_attribute('status', 0)
      redirect_to :action => 'index'
    end
  end
end
