class MainController < ApplicationController
  
  def login
   @current_user = Account.find_by_username_and_password( params[:login], params[:password]) 
   @announcements = Announcement.find(:all)
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
          render :action => 'login'
      end
    else
      flash[:error] = "Invalid username or password"
      render :action => 'login'
    end  
  end

  def logout
    session[:user_id] = nil
    redirect_to :controller => 'main', :action => 'login'
  end
end
