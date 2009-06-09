class MembersController < ApplicationController
  before_filter :login_required
  def index
    @organization = Organization.find_by_account_id(session[:user_id])
    @members = @organization.members
    @editable = @organization.editable
    @year = Time.now.year
	if Time.now.month >4 && Time.now.month <11
	 @schoolyear = "#{@year.to_s} - #{(@year+1).to_s}"
	 @sem = "1st Semester"
	else
	 @schoolyear = "#{(@year-1).to_s} - #{@year.to_s}"
	 @sem = "2nd Semester"
	end
  end
  
  def new
    @current_user = Organization.find_by_account_id(session[:user_id])
    @members = Array.new(3) { @current_user.members.new }
    @editable = @current_user.editable
    @year = Time.now.year
	if Time.now.month >4 && Time.now.month <11
	 @schoolyear = "#{@year.to_s} - #{(@year+1).to_s}"
	 @sem = "1st Semester"
	else
	 @schoolyear = "#{(@year-1).to_s} - #{@year.to_s}"
	 @sem = "2nd Semester"
	end
  end
  
  def create
    @current_user = Organization.find_by_account_id session[:user_id]
    @editable = @current_user.editable
    @year = Time.now.year
	if Time.now.month >4 && Time.now.month <11
	 @schoolyear = "#{@year.to_s} - #{(@year+1).to_s}"
	 @sem = "1st Semester"
	else
	 @schoolyear = "#{(@year-1).to_s} - #{@year.to_s}"
	 @sem = "2nd Semester"
	end
	
	@members = params[:members].values.collect { |member| @current_user.members.new(member)}
	if @members.all?(&:valid?)
	 @members.each(&:save!)
      redirect_to :action => 'form3'
    else
      render :action => 'new'
    end
  end
  
  def form3
    @current_user = Organization.find_by_account_id(session[:user_id])
    @editable = @current_user.editable
    @members = @current_user.members.all(:conditions => "position != 'MEMBER'") 
    @status = @current_user.status
    @year = Time.now.year
	if Time.now.month >4 && Time.now.month <11
	 @schoolyear = "#{@year.to_s} - #{(@year+1).to_s}"
	 @sem = "1st Semester"
	else
	 @schoolyear = "#{(@year-1).to_s} - #{@year.to_s}"
	 @sem = "2nd Semester"
	end
  end
  
  def upload_members
    @members = Organization.find_by_account_id(session[:user_id])
	@upload = params[:upload]
	if @upload['datafile'] == ""
	  flash[:error] = "Please Choose a File to be Uploaded"
	  redirect_to :controller => 'members', :action => 'index'
	else
	@name = @upload['datafile'].original_filename.to_s
	if @name.length < 5
		flash[:error] = "File not supported, upload only (txt) file format"
		redirect_to :controller => 'members', :action => 'index'
	else
		@name = @name.slice(@name.length-4,@name.length)
		if @name == ".txt"
		    @year = Time.now.year
	        if Time.now.month >4 && Time.now.month <11
	           @schoolyear = "#{@year.to_s}-#{(@year+1).to_s}"
	        else
	           @schoolyear = "#{(@year-1).to_s}-#{@year.to_s}"
	        end
			@directory_path = "public/data/"+@schoolyear+"/"+@members.name+"/"
			post = DataFile.save(params[:upload], @directory_path)
			@filename = (params[:upload])
			@filename = @filename['datafile'].original_filename.to_s
			if File.size("#{@directory_path}/#{@filename}").to_i > 1000000
				File.delete("#{@directory_path}/#{@filename}")
				flash[:error] = "Filesize to big only file size lessthan 2 MB is accepted"
				redirect_to :controller => 'members', :action => 'index'
			else
				flash[:notice] = "File Has Been Uploaded Successfully"
				parse_members(@filename, @directory_path)
				File.delete("#{@directory_path}/#{@filename}")
				redirect_to :controller => 'organizations', :action => 'show_forms'
			end
		else
			flash[:error] = "File not supported, upload only (txt) file format"
			redirect_to :controller => 'members', :action => 'index'
		end
	  end
	end
  end
  
  def form4
    @current_user = Organization.find_by_account_id(session[:user_id])
    @editable = @current_user.editable
    @members = @current_user.members.all(:conditions => "position == 'MEMBER'") 
    @status = @current_user.status
    @year = Time.now.year
	if Time.now.month >4 && Time.now.month <11
	 @schoolyear = "#{@year.to_s} - #{(@year+1).to_s}"
	 @sem = "1st Semester"
	else
	 @schoolyear = "#{(@year-1).to_s} - #{@year.to_s}"
	 @sem = "2nd Semester"
	end
  end
   
  def destroy
    @current_user = Organization.find_by_account_id(session[:user_id])
    @members = @current_user.members
    @status = @current_user.status
    
    if @status == 'Not Renewed'
      if @current_user.members.find(params[:id]).destroy
        redirect_to :back
      else
        render :back
      end
    else
      flash[:error] = 'Application period is closed or you may have already submitted you application to OSA.'
      redirect_to :back
    end
  end
   
  def parse_members(file, directory_path)
    @current_user = Organization.find_by_account_id(session[:user_id])
    f = DataFile.open(file, directory_path)

    while not f.eof?
      m = f.gets.split ","
      
      m.each do |i|
        i.strip!
      end  
      
      if (m[1].split "@")[-1] == "up.edu.ph"
        @student = Student.find_by_student_no(m[0].to_i)
        if Student.all.empty? or @student.nil?
          @student = Student.new(:id => m[0].to_i, :student_no => m[0].to_i , :webmail => m[1], :gender => 'f', :degree_program => 'BS').save
        end
        
        if @current_user.members.find_by_student_id(@student.id).nil?
          @current_user.members.new(:student_id => @student.id, :position => (m[2, m.length].join).upcase).save
        end
      else
        #inform user for invalid webmail
      end
      
    end    
    f.close
  end

end