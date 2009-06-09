# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time


  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '5402777561473c9025de98853ad8e719'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
   filter_parameter_logging :password
  
  before_filter :fetch_logged_in_user

  protected 
    def fetch_logged_in_user 
      return unless session[:user_id] 
      @current_user = Account.find_by_id(session[:user_id])
      case @current_user
      when 'OSA'
        @current_user = Osa.find_by_account_id(session[:user_id])
      when 'ORGANIZATION'
        @current_user = Organization.find_by_account_id(session[:user_id])
      end
    end
    
    def logged_in?
      !@current_user.nil?
    end
    helper_method :logged_in?
    
    def login_required
      return true if logged_in?
      redirect_to :controller => 'main' and flash[:error] = "You must log in first" and return false
    end
    
end

