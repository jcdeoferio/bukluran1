require 'pdfdrawer'
require 'find'

class OsasController < ApplicationController
  before_filter :login_required
  @organizationList = []
  @usernameList = []
  @passwordList = []
  @emailList = []
  @total = 0
  def index
    @announcements = Announcement.all
    @pending = Organization.all(:conditions => "status = 'Application Pending'")
    @isopen = Osa.find_by_account_id(session[:user_id]).isopen
  end

  def start_app
    Organization.update_all("editable = '#{true}'")
    Organization.update_all("status = 'Not Renewed'")
    Osa.update_all("isopen = '#{true}'")
    @allOrganization = Organization.find(:all)
        @year = Time.now.year
		if Time.now.month >4 && Time.now.month <11
		  @schoolyear = @year.to_s+"-"+(@year-1).to_s
		  @sem = "1stSem"
		else
		  @schoolyear = (@year-1).to_s+"-"+@year.to_s
		  @sem = "2ndSem"
	    end
		for organization in @allOrganization	
			@newfolder = "public/data/#{@schoolyear}/#{organization.name}/#{@sem}/"
			FileUtils.mkdir_p @newfolder+"Form_2"
			FileUtils.mkdir_p @newfolder+"Form_7"
			FileUtils.mkdir_p @newfolder+"Events"
			FileUtils.mkdir_p @newfolder+"Awards"
		end
    redirect_to :action => "index"
  end

  def end_app
    @allOrganization = Organization.find(:all)
    for organization in @allOrganization
      if organization.status == 'Renewed'
        PdfDrawer.draw(organization, filepath(organization), true)
      end
	end
    Organization.update_all("editable = '#{false}'")
    Osa.update_all("isopen = '#{false}'")
    redirect_to :action => "index"
  end

  def approve
    @organization = Organization.find(params[:id])
    if @organization.update_attribute('status', 'Renewed')
      flash[:notice] = "Application Successfully Approved"
      redirect_to :action => 'show_forms', :id => @organization.id
    end
  end

  def reject
    @organization = Organization.find(params[:id])
    if @organization.update_attribute('status', 'Application Rejected')
      flash[:notice] = "Application Successfully Rejected"
      redirect_to :action => 'show_forms', :id => @organization.id
    end
  end
  
  def reopen
    @organization = Organization.find(params[:id])
    if @organization.update_attribute('editable', true)
      flash[:notice] = "Application Successfully Allowed to be Modified"
      redirect_to :action => 'show_forms', :id => @organization.id
    end
  end
  
  def post_comment
    @organization = Organization.find(params[:id])
    if @organization.update_attribute('comment', params[:organization][:comment])
      flash[:notice] = "Application Comment Successfully Posted"
    else
      flash[:error] = "Application Comment Not Posted"
    end
    redirect_to :action => 'show_forms', :id => @organization.id
  end

  def new_account
  end

  def show_forms
    @organization = Organization.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        send_data PdfDrawer.draw(@organization, filepath(@organization), false), :filename => 'organization.pdf', :type => 'application/pdf', :disposition => 'inline'
      end
    end
  end

  def form1
    @organization = Organization.find(params[:id])
    #kapag papalitan ang db baka palitan natin yung conditions. flag lang. natagalan ako dahil sa errors ng SQL T_T
    @mt = Member.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ?', 'm', @organization.id]).size
    @ft = Member.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ?', 'f', @organization.id]).size
    @msop = Member.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ? AND student_no < ? AND student_no > ? AND (degree_program = ? OR degree_program = ?)', 'm', @organization.id, (Time.now.year)*100000, (Time.now.year-2)*100000, 'BS', 'BA']).size
    @fsop = Member.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ? AND student_no < ? AND student_no > ? AND (degree_program = ? OR degree_program = ?)', 'f', @organization.id, (Time.now.year)*100000, (Time.now.year-2)*100000, 'BS', 'BA']).size
    @mjun = Member.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ? AND student_no < ? AND student_no > ? AND (degree_program = ? OR degree_program = ?)', 'm', @organization.id, (Time.now.year-2)*100000, (Time.now.year-3)*100000, 'BS', 'BA']).size
    @fjun = Member.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ? AND student_no < ? AND student_no > ? AND (degree_program = ? OR degree_program = ?)', 'f', @organization.id, (Time.now.year-2)*100000, (Time.now.year-3)*100000, 'BS', 'BA']).size
    @msen = Member.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ? AND student_no < ?', 'm', @organization.id, (Time.now.year-3)*100000]).size
    @fsen = Member.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ? AND student_no < ?', 'f', @organization.id, (Time.now.year-3)*100000]).size
    @mphd = Member.all(:joins => :student, :conditions => ['degree_program = ? AND gender = ? AND organization_id = ?', 'PHD', 'm', @organization.id]).size
    @mmas = Member.all(:joins => :student, :conditions => ['(degree_program = ? OR degree_program = ?) AND gender = ? AND organization_id = ?', 'MS', 'MA', 'm', @organization.id]).size
    @fphd = Member.all(:joins => :student, :conditions => ['degree_program = ? AND gender = ? AND organization_id = ?', 'PHD', 'f', @organization.id]).size
    @fmas = Member.all(:joins => :student, :conditions => ['(degree_program = ? OR degree_program = ?) AND gender = ? AND organization_id = ?', 'MS', 'MA', 'f', @organization.id]).size
    @mpgc = Member.all(:joins => :student, :conditions => ['degree_program = ? AND gender = ? AND organization_id = ?', 'PGC', 'm', @organization.id]).size
    @fpgc = Member.all(:joins => :student, :conditions => ['degree_program = ? AND gender = ? AND organization_id = ?', 'PGC', 'f', @organization.id]).size
  end
  
  def form2
	@data = Organization.find(params[:id])
	@year = Time.now.year
	if Time.now.month >4 && Time.now.month <11
	 @schoolyear = "#{@year.to_s}-#{(@year+1).to_s}"
	 @sem = "1stSem"
	else
	 @schoolyear = "#{(@year-1).to_s}-#{@year.to_s}"
	 @sem = "2ndSem"
	end
	@files = []
	@path = "/data/#{@schoolyear}/#{@data.name}/#{@sem}/Form_2"
	Find.find("public#{@path}") do |path|
	 if FileTest.directory?(path)
	   next
	 else
	   fname = File.basename(path)
	   @files << fname.camelize.to_s
	 end
	end
	if @files.empty?
	  flash[:notice] = "Form 2 file not yet uploaded"
	end
  end
  
  def form5
  end
  
  def form6
    @organization = Organization.find(params[:id])
    @events = @organization.events
  end

  def form7
	@data = Organization.find(params[:id])
	@year = Time.now.year
	if Time.now.month >4 && Time.now.month <11
	 @schoolyear = "#{@year.to_s}-#{(@year+1).to_s}"
	 @sem =  "1stSem"
	else
	 @schoolyear = "#{(@year-1).to_s}-#{@year.to_s}"
	 @sem =  "2ndSem"
	end
	@files = []
	@path = "/data/#{@schoolyear}/#{@data.name}/#{@sem}/Form_7"
	Find.find("public#{@path}") do |path|
		if FileTest.directory?(path)
		  next
		else
		  fname = File.basename(path)
		  @files << fname.camelize.to_s
		end
	end
	if @files.empty?
	  flash[:notice] = "Form 7 file not yet uploaded"
	end
  end

  def form_awards
    @organization = Organization.find(params[:id])
    @awards = @organization.awards 
	@year = Time.now.year
	if Time.now.month >4 && Time.now.month <11
	 @schoolyear = "#{@year.to_s}-#{(@year+1).to_s}"
	 @sem = "1stSem"
	else
	 @schoolyear = "#{(@year-1).to_s}-#{@year.to_s}"
	 @sem = "2ndSem"
	end
	@files = []
	@path = "/data/#{@schoolyear}/#{@organization.name}/#{@sem}/Awards"
	Find.find("public#{@path}") do |path|
	 if FileTest.directory?(path)
	   next
	 else
	   fname = File.basename(path)
	   @files << fname.camelize.to_s
	 end
	end
	if @files.empty?
	  flash[:notice] = "No file uploaded"
	end
  end
  
  def form_reports #wrong content
      @organization = Organization.find(params[:id])
    @events = @organization.event_reports
  end
  
  def form3
    @organization = Organization.find(params[:id])
    @members= @organization.members.all(:conditions => "position != 'MEMBER'")
  end
  
  def form4
    @organization = Organization.find(params[:id])
    @members = @organization.members.all(:conditions => "position = 'MEMBER'")
  end

  def create
    @organization = Organization.new(:name => params[:name])
    @organization.status = 'Not Renewed'
    @organization.editable = Osa.find_by_account_id(session[:user_id]).isopen
    @password = (params[:username].crypt "afeGRReD83erEweytu8968YuO776POLdN343m4534DsAz3").downcase!
    @password.gsub! ".", "n"
    @password.gsub! "/", "k"
    @password.gsub! ",", "y"

    @account = Account.new(:username => params[:username], :password => @password, :id => params[:id], :group => 'ORGANIZATION') #try removing the id
    @organization.account = @account
    if @account.save and @organization.save
  	 @year = Time.now.year
  	 if Time.now.month >4 && Time.now.month <11
  	  @schoolyear = "#{@year.to_s}-#{(@year+1).to_s}"
  	  @sem = "1stSem"
  	 else
  	  @schoolyear = "#{(@year-1).to_s}-#{@year.to_s}"
  	  @sem = "2ndSem"
  	 end
     @newfolder = "public/data/#{@schoolyear}/#{@organization.name}/#{@sem}/"
      FileUtils.mkdir_p @newfolder+"Form_2"
      FileUtils.mkdir_p @newfolder+"Form_7"
      FileUtils.mkdir_p @newfolder+"Events"
      FileUtils.mkdir_p @newfolder+"Awards"
      flash[:notice] = "Successfully Created New Organization Account"
      redirect_to :action => 'show_account', :id => @account.id
    else
      render :action => 'new_account'
    end 
  end
  
  def show_account
    @account = Account.find(params[:id])  
    @name = Organization.find_by_account_id(params[:id]).name
  end

  def search_org(search_data)
    result = []
    for o in Organization.all
      org_name = o.name.upcase.split
      org_acr = []
      if o.acronym
        org_acr = o.acronym.upcase.split     
      end
      if org_name.member? search_data.upcase or org_acr.member? search_data.upcase
        result.push o
      end
    end
    
    if result.empty?
      return nil
    end
    return result
  end

  def search_result
    @organizations = search_org(params[:name])
  end

  def show_all_orgs
    @organizations = Organization.all
  end

  def show_pending_apps
    @pending = Organization.all(:conditions => "status = 'Application Pending'")
  end

  def search
  end
  
  def view_form
    @data = Organization.find(params[:id])
    @pathname = params[:pname]
    @form = params[:form]
  end
  
  def filepath(org)
    @year = Time.now.year
	if Time.now.month >4 && Time.now.month <11
      @schoolyear = @year.to_s+"-"+(@year+1).to_s
      @sem = "1stSem"
	else
      @schoolyear = (@year-1).to_s+"-"+@year.to_s
      @sem = "2ndSem"
    end
    return "#{@schoolyear}/#{org.name}/#{@sem}"
  end
  
  def uporgname
  end
  
  def upusername
  end
  
  def uppassword
  end
  
  def upemail
  end
  
  def uploadOrgName
	@upload = params[:upload]
	if @upload['datafile'] == ""
	   flash[:error] = "Please Choose a File to Upload"
	else
	  @name = File.extname("#{@upload['datafile'].original_filename}")
		if @name == ".txt"
			@directory_path = "public/data/orgname"
			post = DataFile.save(params[:upload], @directory_path)
			@filename = (params[:upload])
			@filename = @filename['datafile'].original_filename.to_s
			if File.size("#{@directory_path}/#{@filename}").to_i > 1000000
				File.delete("#{@directory_path}/#{@filename}")
				flash[:error] = "Filesize to big only file size lessthan 1 MB is accepted"
			else
				@counter = 0
				File.open("#{@directory_path}/#{@filename}", "r") { |@infile|
					@infile.each_line('.'){ |@line|
						@organizationList << @line
						@counter++
					}
				}
				File.delete("#{@directory_path}/#{@filename}")
				flash[:notice] = "File Has Been Uploaded Successfully"
			end
		else
			flash[:error] = "File format not supported, upload .txt file format only."
		end
	end
	   @total = @counter
	   redirect_to :controller => 'osas', :action => 'uporgname'
  end
  
  def uploadUserName
	@upload = params[:upload]
	if @upload['datafile'] == ""
	   flash[:error] = "Please Choose a File to Upload"
	else
	  @name = File.extname("#{@upload['datafile'].original_filename}")
		if @name == ".txt"
			@directory_path = "public/data/username"
			post = DataFile.save(params[:upload], @directory_path)
			@filename = (params[:upload])
			@filename = @filename['datafile'].original_filename.to_s
			if File.size("#{@directory_path}/#{@filename}").to_i > 1000000
				File.delete("#{@directory_path}/#{@filename}")
				flash[:error] = "Filesize to big only file size lessthan 1 MB is accepted"
			else
				@counter = 0
				File.open("#{@directory_path}/#{@filename}", "r") { |@infile|
					@infile.each_line('.') { |@line|
						@usernameList << @line
						@counter++
					}
				}
				File.delete("#{@directory_path}/#{@filename}")
				flash[:notice] = "File Has Been Uploaded Successfully"
			end
		  else
			flash[:error] = "File format not supported, upload .txt file format only."
		  end
	   end
	   @total = @counter
	   redirect_to :controller => 'osas', :action => 'upusername'
  end
  
  def uploadPassword
  	@upload = params[:upload]
	if @upload['datafile'] == ""
	   flash[:error] = "Please Choose a File to Upload"
	else
	  @name = File.extname("#{@upload['datafile'].original_filename}")
		if @name == ".txt"
			@directory_path = "public/data/password"
			post = DataFile.save(params[:upload], @directory_path)
			@filename = (params[:upload])
			@filename = @filename['datafile'].original_filename.to_s
			if File.size("#{@directory_path}/#{@filename}").to_i > 1000000
				File.delete("#{@directory_path}/#{@filename}")
				flash[:error] = "Filesize to big only file size lessthan 1 MB is accepted"
			else
				File.open("#{@directory_path}/#{@filename}", "r") { |@infile|
					@infile.each_line('.') { |@line|
						@passwordList << @line
						@counter++
					}
				}
				File.delete("#{@directory_path}/#{@filename}")
				flash[:notice] = "File Has Been Uploaded Successfully"
			end
		  else
			flash[:error] = "File format not supported, upload .txt file format only."
		  end
	   end
	   @total = @counter
	   redirect_to :controller => 'osas', :action => 'uppassword'
  end
  
  def uploadEmailAdd
    @upload = params[:upload]
	if @upload['datafile'] == ""
	   flash[:error] = "Please Choose a File to Upload"
	else
	  @name = File.extname("#{@upload['datafile'].original_filename}")
		if @name == ".txt"
			@directory_path = "public/data/email"
			post = DataFile.save(params[:upload], @directory_path)
			@filename = (params[:upload])
			@filename = @filename['datafile'].original_filename.to_s
			if File.size("#{@directory_path}/#{@filename}").to_i > 1000000
				File.delete("#{@directory_path}/#{@filename}")
				flash[:error] = "Filesize to big only file size lessthan 1 MB is accepted"
			else
				@counter = 0
				File.open("#{@directory_path}/#{@filename}", "rb") { |@infile|
					@infile.each_line('.'){ |@line| 
					@emailList << @line
					@counter++}}
				File.delete("#{@directory_path}/#{@filename}")
				flash[:notice] = "File Has Been Uploaded Successfully"
			end
		  else
			flash[:error] = "File format not supported, upload .txt file format only."
		  end
	   end
	   @total = @counter
	   redirect_to :controller => 'osas', :action => 'upemail'
  end
  
  def createAll
	@counter = 0
	@total.times do
		@organization = Organization.new(:name => @organizationList[@counter])
		@organization.status = 'Not Renewed'
		@organization.editable = Osa.find_by_account_id(session[:user_id]).isopen	
		@account = Account.new(:username => @usernameList[@counter], :password => @passwordList[@counter], :group => 'ORGANIZATION') #try removing the id
		@organization.account = @account
		if @account.save and @organization.save
			@year = Time.now.year
			if Time.now.month >4 && Time.now.month <11
				@schoolyear = "#{@year.to_s}-#{(@year+1).to_s}"
				@sem = "1stSem"
			else
				@schoolyear = "#{(@year-1).to_s}-#{@year.to_s}"
				@sem = "2ndSem"
			end
			@newfolder = "public/data/#{@schoolyear}/#{@organization.name}/#{@sem}/"
			FileUtils.mkdir_p @newfolder+"Form_2"
			FileUtils.mkdir_p @newfolder+"Form_7"
			FileUtils.mkdir_p @newfolder+"Events"
			FileUtils.mkdir_p @newfolder+"Awards"
			flash[:notice] = "Successfully Created New Organization Account"
		else
			flash[:notice] = "Error in creating Organizations"
		end 
	end
	redirect_to :action => 'index'
  end

end
