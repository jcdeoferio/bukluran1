class MainController < ApplicationController
  
  def index
    @announcements = Announcement.all
  end
  
  def login
   @current_user = Account.find_by_username_and_password( params[:login], params[:password]) 
    if @current_user
      session[:user_id] = @current_user.id
      
      case @current_user.group
        when 'ORGANIZATION'
          redirect_to :controller => 'organizations', :action => 'index'
        when 'OSA'
          redirect_to :controller => 'osas', :action => 'index'
        when 'ADMINISTRATOR'
          redirect_to :controller => 'administrators', :action => 'index'
        else
          redirect_to :action => 'index'
      end
    else
      flash[:error] = "Invalid username or password"
      redirect_to :action => 'index'
    end  
  end
  
  def logout
    session[:user_id] = nil
    redirect_to :controller => 'main', :action => 'index'
  end
end
