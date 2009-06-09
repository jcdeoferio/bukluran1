require 'find'

class OrganizationsController < ApplicationController
  before_filter :login_required
  def index
    @announcements = Announcement.find(:all)
    @current_user  = Organization.find_by_account_id(session[:user_id])
  end
  
  def new
    @current_user  = Organization.find_by_account_id(session[:user_id])
    @current_user.members.build
  end
  
  def create
    @current_user  = Organization.find_by_account_id(session[:user_id])
    params[:members].each_value { |member| @current_user.members.build(member) }
    if @current_user.save
      redirect_to :action => 'show_forms'
    else
      render :action => 'new'
    end
  end
  
  def add_member
    @member = Member.new
    respond_to do |format|
      format.js
    end  
  end
  
  def show_forms
     @current_user = Organization.find_by_account_id(session[:user_id])
  end
  
  def update
    @current_user = Organization.find_by_account_id(session[:user_id])
    @editable = @current_user.editable
    
    if @editable
      if @current_user.update_attributes(params[:data])
        redirect_to :action => 'show_forms'
      else
        render :action => 'form1'
      end
    end
  end
  
  def form1 #do not change @data
    @data = Organization.find_by_account_id(session[:user_id])
  end
  
  def form2
    @current_user = Organization.find_by_account_id(session[:user_id])
    @editable = @current_user.editable
    @year = Time.now.year
	if Time.now.month >4 && Time.now.month <11
	 @schoolyear = "#{@year.to_s}-#{(@year+1).to_s}"
	 @sem = "1stSem"
	else
	 @schoolyear = "#{(@year-1).to_s}-#{@year.to_s}"
	 @sem = "2ndSem"
	end
	@files = []
	@path = "/data/#{@schoolyear}/#{@current_user.name}/#{@sem}/Form_2"
	Find.find("public#{@path}") do |path|
	 if FileTest.directory?(path)
	   next
	 else
	   fname = File.basename(path)
	   @files << fname.camelize.to_s
	 end
	end
	if @files.empty?
	  flash[:warning] = "No Uploaded File"
	end
  end
  
  def form7
    @current_user = Organization.find_by_account_id(session[:user_id])
    @editable = @current_user.editable
	@year = Time.now.year
	if Time.now.month >4 && Time.now.month <11 
	 @schoolyear = "#{@year.to_s}-#{(@year+1).to_s}"
	 @sem = "1stSem"
	else
	 @schoolyear = "#{(@year-1).to_s}-#{@year.to_s}"
	 @sem = "2ndSem"
	end
	@files = []
	@path = "/data/#{@schoolyear}/#{@current_user.name}/#{@sem}/Form_7"
	Find.find("public#{@path}") do |path|
	 if FileTest.directory?(path)
	   next
	 else
	   fname = File.basename(path)
	   @files << fname.camelize.to_s
	 end
	end
	if @files.empty?
	  flash[:warning] = "No Uploaded File"
	end
  end
  
  def form2Upload
	@data = Organization.find_by_account_id(session[:user_id])
	@upload = params[:upload]
	@upload = params[:upload]
	if @upload['datafile'] == ""
	  flash[:error] = "Please Choose a File to be Uploaded"
	  redirect_to :controller => 'organizations', :action => 'form2'
	else
	  @name = @upload['datafile'].original_filename.to_s
	  if @name.length < 5
		flash[:error] = "File not supported, upload only (jpg gif png bmp pdf) file format"
		redirect_to :controller => 'organizations', :action => 'form2'
	  else
		@name = @name.slice(@name.length-4,@name.length)
		if @name == ".png" || @name == ".jpg" || @name == ".gif" || @name == ".bmp" || @name == '.pdf'
		    @year = Time.now.year
	        if Time.now.month >4 && Time.now.month <11
	           @schoolyear = "#{@year.to_s}-#{(@year+1).to_s}"
	           @sem = "1stSem"
	        else
	           @schoolyear = "#{(@year-1).to_s}-#{@year.to_s}"
	           @sem = "2ndSem"
	        end
			@directory_path = "public/data/"+@schoolyear+"/"+@data.name+"/"+@sem+"/"+"Form_2"
			post = DataFile.save(params[:upload], @directory_path)
			@filename = (params[:upload])
			@filename = @filename['datafile'].original_filename.to_s
			if File.size("#{@directory_path}/#{@filename}").to_i > 2000000
				File.delete("#{@directory_path}/#{@filename}")
				flash[:error] = "Form 2 Filesize to big only file size lessthan 2 MB is accepted"
				redirect_to :controller => 'organizations', :action => 'form2'
			else
				flash[:notice] = "Form 2 File Has Been Uploaded Successfully"
				redirect_to :controller => 'organizations', :action => 'show_forms'
			end
		  else
			flash[:error] = "File not supported, upload only (jpg gif png bmp pdf) file format"
			redirect_to :controller => 'organizations', :action => 'form2'
		  end
	   end
	 end
  end
  
  def form7Upload
	@data = Organization.find_by_account_id(session[:user_id])
	@upload = params[:upload]
	@upload = params[:upload]
	@sem = nil
	if @upload['datafile'] == ""
	   flash[:error] = "Please Choose a File to be Uploaded"
	   redirect_to :controller => 'organizations', :action => 'form7'
	else
	  @name = @upload['datafile'].original_filename.to_s
	  if @name.length < 5
		flash[:error] = "File not supported, upload only (jpg gif png bmp) file format"
		redirect_to :controller => 'organizations', :action => 'form7'
	  else
		@name = @name.slice(@name.length-4,@name.length)
		if @name == ".png" || @name == ".jpg" || @name == ".gif" || @name == ".bmp"
		    @year = Time.now.year
	        if Time.now.month >4 && Time.now.month <11
	           @schoolyear = "#{@year.to_s}-#{(@year+1).to_s}"
	           @sem = "1stSem"
	        else
	           @schoolyear = "#{(@year-1).to_s}-#{@year.to_s}"
	           @sem = "2ndSem"
	        end
			@directory_path = "public/data/"+@schoolyear+"/"+@data.name+"/"+@sem+"/"+"Form_7"
			post = DataFile.save(params[:upload], @directory_path)
			@filename = (params[:upload])
			@filename = @filename['datafile'].original_filename.to_s
			if File.size("#{@directory_path}/#{@filename}").to_i > 2000000
				File.delete("#{@directory_path}/#{@filename}")
				flash[:error] = "Form 7 Filesize to big only file size lessthan 2 MB is accepted"
				redirect_to :controller => 'organizations', :action => 'form2'
			else
				flash[:notice] = "Form 7 File Has Been Uploaded Successfully"
				redirect_to :controller => 'organizations', :action => 'show_forms'
			end
		  else
			flash[:error] = "File not supported, upload only (jpg gif png bmp) file format"
			redirect_to :controller => 'organizations', :action => 'form7'
		  end
	   end
	 end
  end
  
  def submit
    @current_user = Organization.find_by_account_id(session[:user_id])
    @editable = @current_user.editable
    @status = @current_user.status
    
    if @editable
      if @current_user.update_attribute('status', 'Application Pending') and @current_user.update_attribute('editable', false)
        redirect_to :action => 'index'
      end
    else
      flash[:error] = 'Application period is closed or you may have already sumbitted your application to OSA.'
      redirect_to :action => 'show_forms'
    end
  end
  
  def change_password
    @organization = Organization.find_by_account_id(session[:user_id])
  end
  
  def update_account
    @organization = Organization.find(params[:id])
    @account = Account.find(@organization.account_id)
    
    if @account.password == params[:org][:current_password]
      if params[:org][:new_password] == params[:org][:confirm_password]
        if params[:org][:new_password].length >= 5
          if @account.update_attribute("password", params[:org][:new_password])
            flash[:notice] = "Successfully Changed Password!"
          end
        else
          flash[:error] = "New password length too short"
        end
          redirect_to :action => 'change_password'
      else
        flash[:error] = "Passwords do not match each other"
        redirect_to :action => 'change_password'
      end
    else
      flash[:error] = "Wrong Password"
      redirect_to :action => 'change_password'
    end
  end
  
  def view_form
    @current_user = Organization.find_by_account_id(session[:user_id])
    @pathname = params[:pname]
    @form = params[:form]
  end
  
  def deletefile
    @current_user = Organization.find_by_account_id(session[:user_id])
    File.delete(params[:pname])
    redirect_to :action => params[:form]
  end
  
end
