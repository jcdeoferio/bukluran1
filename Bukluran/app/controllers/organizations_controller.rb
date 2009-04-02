require 'find'

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
  
  def form2Upload
	@data = Organization.find_by_account_id(session[:user_id])
	@upload = params[:upload]
	@name = @upload['datafile'].original_filename.to_s
	if @name.length < 5
		flash[:notice] = "File not supported, upload only (jpg gif png bmp) file format #{@size}"
		redirect_to :controller => 'organizations', :action => 'form2'
	else
		@name = @name.slice(@name.length-4,@name.length)
		if @name == ".png" || @name == ".jpg" || @name == ".gif" || @name == ".bmp"
			@yearsem = Time.now.year.to_s
			if Time.now.month >5 && Time.now.month <11
				@yearsem = @yearsem + "_1stSem"
			else
				@yearsem = @yearsem + "_2ndSem"
			end
			@directory_path = "public/data/"+@data.name+"/"+@yearsem+"/"+"Form_2"
			post = DataFile.save(params[:upload], @directory_path)
			flash[:notice] = "Form 2 File Has Been Uploaded Successfully"
			redirect_to :controller => 'organizations', :action => 'show'
		else
			flash[:notice] = "File not supported, upload only (jpg gif png bmp) file format"
			redirect_to :controller => 'organizations', :action => 'form2'
		end
	end
  end
  
  def form7
    @data = Organization.find_by_account_id(session[:user_id])
  end
  
  def form7Upload
	@data = Organization.find_by_account_id(session[:user_id])
	@upload = params[:upload]
	@name = @upload['datafile'].original_filename.to_s
	if @name.length < 5
		flash[:notice] = "File not supported, upload only (jpg gif png bmp) file format"
		redirect_to :controller => 'organizations', :action => 'form7'
	else
		@name = @name.slice(@name.length-4,@name.length)
		if @name == ".png" || @name == ".jpg" || @name == ".gif" || @name == ".bmp"
			@yearsem = Time.now.year.to_s
			if Time.now.month >5 && Time.now.month <11
				@yearsem = @yearsem + "_1stSem"
			else
				@yearsem = @yearsem + "_2ndSem"
			end
			@directory_path = "public/data/"+@data.name+"/"+@yearsem+"/"+"Form_7"
			post = DataFile.save(params[:upload], @directory_path)
			flash[:notice] = "Form 7 File Has Been Uploaded Successfully"
			redirect_to :controller => 'organizations', :action => 'show'
		else
			flash[:notice] = "File not supported, upload only (jpg gif png bmp) file format"
			redirect_to :controller => 'organizations', :action => 'form7'
		end
	end
  end
  
  def submit
     @data = Organization.find_by_account_id(session[:user_id])
    
    if @data.update_attribute('status', 0)
      redirect_to :action => 'index'
    end
  end
   
end
