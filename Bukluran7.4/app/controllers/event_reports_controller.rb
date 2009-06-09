class EventReportsController < ApplicationController
  before_filter :login_required
  def index
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
	@path = "/data/#{@schoolyear}/#{@current_user.name}/#{@sem}/Events"
	Find.find("public#{@path}") do |path|
	 if FileTest.directory?(path)
	   next
	 else
	   fname = File.basename(path)
	   @files << fname.camelize.to_s
	 end
	end
	if @files.empty?
	  flash[:notice] = "No Uploaded File"
	end
  end
  
  def upload_process
  	@data = Organization.find_by_account_id(session[:user_id])
	@upload = params[:upload]
	if @upload['datafile'] == ""
	   flash[:error] = "Please Choose a File to be Uploaded"
	else
	 @name = @upload['datafile'].original_filename.to_s
	 if @name.length < 5
		flash[:error] = "File not supported, upload only (jpg gif png bmp) file format"
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
			@directory_path = "public/data/"+@schoolyear+"/"+@data.name+"/"+@sem+"/"+"Events"
			post = DataFile.save(params[:upload], @directory_path)
			@filename = (params[:upload])
			@filename = @filename['datafile'].original_filename.to_s
			if File.size("#{@directory_path}/#{@filename}").to_i > 2000000
				File.delete("#{@directory_path}/#{@filename}")
				flash[:error] = "Filesize to big only file size lessthan 2 MB is accepted"
			else
				flash[:notice] = "New Report Has Been Uploaded Successfully"
			end
		else
			flash[:error] = "File not supported, upload only (jpg gif png bmp) file format"
		end
	  end
	end
	redirect_to :controller => 'event_reports', :action => 'index'
  end

  def new
  end

  def create
  end

  def show
  end
  
  def view_form
    @current_user = Organization.find_by_account_id(session[:user_id])
    @pathname = params[:pname]
  end
  
  def deletefile
    @current_user = Organization.find_by_account_id(session[:user_id])
    File.delete(params[:pname])
    redirect_to :action => 'index'
  end

end
