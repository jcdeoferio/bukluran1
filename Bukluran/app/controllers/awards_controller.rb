class AwardsController < ApplicationController
  def index
    @awards = Organization.find_by_account_id(session[:user_id]).awards
  end

  def new
    @awards = Organization.find_by_account_id(session[:user_id]).awards
    @data = @awards.new
  end
  
  def create
    @award = Organization.find(session[:user_id]).awards.new(params[:award])
    
    if @award.save
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
    
  end

end
