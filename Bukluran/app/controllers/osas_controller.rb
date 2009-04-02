require 'lib/pdfdrawer'
require 'find'

class OsasController < ApplicationController
  def index
    @user = Osa.find_by_account_id(session[:user_id])
    @announcements = Announcement.all
    @pending = Organization.all(:conditions => "status = 0")
  end
  
  def start_app
    @user = Osa.find_by_account_id(session[:user_id])
    Organization.update_all("status = -1")
	@allOrganization = Organization.find(:all)
		for organization in @allOrganization
			@yearsem = Time.now.year.to_s
			if Time.now.month >5 && Time.now.month <11
				@yearsem = @yearsem + "_1stSem"
			else
				@yearsem = @yearsem + "_2ndSem"
			end
			@newfolder = "public/data/"+organization.name+"/"+@yearsem+"/"
			FileUtils.mkdir_p @newfolder+"Form_2"
			FileUtils.mkdir_p @newfolder+"Form_7"
			FileUtils.mkdir_p @newfolder+"Events"
			FileUtils.mkdir_p @newfolder+"Awards"
		end
    redirect_to 'osas'
  end
  
  def end_app
  end
  
  def new_app
    @user = Osa.find_by_account_id(session[:user_id])
    @newOrg = Organization.all(:conditions => "status = -1")
  end
  def app_show
    @user = Osa.find_by_account_id(session[:user_id])
    @orgdata = Organization.find(params[:id])
  end
  def show_only
	@user = Osa.find_by_account_id(session[:user_id])
	@orgdata = Organization.find(params[:id])
  end
  def new
	@user = Osa.find_by_account_id(session[:user_id])
  end
  def show_forms
    @user = Osa.find_by_account_id(session[:user_id])
    @orgdata = Organization.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        send_data PdfDrawer.draw(@orgdata), :filename => 'organization.pdf', :type => 'application/pdf', :disposition => 'inline'
      end
    end
  end
  
  def form1
    @user = Osa.find_by_account_id(session[:user_id])
    @orgdata = Organization.find(params[:id])
    #kapag papalitan ang db baka palitan natin yung conditions. flag lang. natagalan ako dahil sa errors ng SQL T_T
    @mt = Membership.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ?', 'm', @orgdata.id]).size
    @ft = Membership.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ?', 'f', @orgdata.id]).size
    @msop = Membership.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ? AND student_no < ? AND student_no > ?', 'm', @orgdata.id, (Time.now.year)*100000, (Time.now.year-2)*100000]).size
    @fsop = Membership.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ? AND student_no < ? AND student_no > ?', 'f', @orgdata.id, (Time.now.year)*100000, (Time.now.year-2)*100000]).size
    @mjun = Membership.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ? AND student_no < ? AND student_no > ?', 'm', @orgdata.id, (Time.now.year-2)*100000, (Time.now.year-3)*100000]).size
    @fjun = Membership.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ? AND student_no < ? AND student_no > ?', 'f', @orgdata.id, (Time.now.year-2)*100000, (Time.now.year-3)*100000]).size
    @msen = Membership.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ? AND student_no < ?', 'm', @orgdata.id, (Time.now.year-3)*10000]).size
    @fsen = Membership.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ? AND student_no < ?', 'f', @orgdata.id, (Time.now.year-3)*10000]).size
    @mphd = Membership.all(:joins => :student, :conditions => ['degree_program = ? AND gender = ? AND organization_id = ?', 'PHD', 'm', @orgdata.id]).size
    @mmas = Membership.all(:joins => :student, :conditions => ['degree_program = ? AND gender = ? AND organization_id = ?', 'MAS', 'm', @orgdata.id]).size
    @fphd = Membership.all(:joins => :student, :conditions => ['degree_program = ? AND gender = ? AND organization_id = ?', 'PHD', 'f', @orgdata.id]).size
    @fmas = Membership.all(:joins => :student, :conditions => ['degree_program = ? AND gender = ? AND organization_id = ?', 'MAS', 'f', @orgdata.id]).size
    @mpgc = Membership.all(:joins => :student, :conditions => ['degree_program = ? AND gender = ? AND organization_id = ?', 'PGC', 'm', @orgdata.id]).size
    @fpgc = Membership.all(:joins => :student, :conditions => ['degree_program = ? AND gender = ? AND organization_id = ?', 'PGC', 'f', @orgdata.id]).size
  end
  
  def form2
	@user = Osa.find_by_account_id(session[:user_id])
	@data = Organization.find(params[:id])
	@yearsem = Time.now.year.to_s
	if Time.now.month >5 && Time.now.month <11
		@yearsem = @yearsem + "_1stSem"
	else
		@yearsem = @yearsem + "_2ndSem"
	end
	@files = []
	Find.find("public/data/#{@data.name}/#{@yearsem}/Form_2") do |path|
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
  
  def form7
	@user = Osa.find_by_account_id(session[:user_id])
	@data = Organization.find(params[:id])
	@yearsem = Time.now.year.to_s
	if Time.now.month >5 && Time.now.month <11
		@yearsem = @yearsem + "_1stSem"
	else
		@yearsem = @yearsem + "_2ndSem"
	end
	@files = []
	Find.find("public/data/#{@data.name}/#{@yearsem}/Form_7") do |path|
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
    @user = Osa.find_by_account_id(session[:user_id])
    @orgdata = Organization.find(params[:id])
  end
  
  def form_reports
    @user = Osa.find_by_account_id(session[:user_id])
    @orgdata = Organization.find(params[:id])
  end
  
  def create
    @organization = Organization.new(:name => params[:name])
    @organization.status = -1
    @account = Account.new(:username => params[:username], :password => params[:password], :id => params[:id], :group => 'ORGANIZATION')
    @organization.account = @account
    if @account.save and @organization.save
		@yearsem = Time.now.year.to_s
		if Time.now.month >5 && Time.now.month <11
			@yearsem = @yearsem + "_1stSem"
		else
			@yearsem = @yearsem + "_2ndSem"
		end
		@newfolder = "public/data/"+@organization.name+"/"+@yearsem+"/"
		FileUtils.mkdir_p @newfolder+"Form_2"
		FileUtils.mkdir_p @newfolder+"Form_7"
		FileUtils.mkdir_p @newfolder+"Events"
		FileUtils.mkdir_p @newfolder+"Awards"
      flash[:notice] = "Successfully Created New Organization Account"
      redirect_to :controller => 'osas', :action => 'new_app'
    else
      render :action => "new_app"
    end 
  end
  
  def search_all_org(search_data)
	@user = Osa.find_by_account_id(session[:user_id])
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
  
  def basic_search
	@user = Osa.find_by_account_id(session[:user_id])
    @organizations = search_all_org params[:name]
  end
  
  def showall
	@user = Osa.find_by_account_id(session[:user_id])
	@organization = Organization.find(:all)
  end

  def show
    @user = Osa.find_by_account_id(session[:user_id])
    @pending = Organization.all(:conditions => "status = 0")
    if @pending.empty?
      flash[:notice] = "No pending application"
    end
  end
  
  def approve
	@user = Osa.find_by_account_id(session[:user_id])
    @organization = Organization.find(params[:id])
    if @organization.status = 0
      if @organization.update_attribute('status', 1)
        redirect_to :action => 'show'
      end
    else
      if @organization.update_attribute('status', 1)
        redirect_to :action => 'new_app'
      end
    end 
  end
    
  def reject
	@user = Osa.find_by_account_id(session[:user_id])
    @organization = Organization.find(params[:id])
    if @organization.status = 0
      if @organization.update_attribute('status', -1)
        redirect_to :action => 'show'
      end
    else
      if @organization.destroy
        redirect_to :action => 'new_app'
      end
    end 
  end
  def search
	@user = Osa.find_by_account_id(session[:user_id])
  end
  
  def view_form
	@user = Osa.find_by_account_id(session[:user_id])
	@data = Organization.find(params[:id])
	@yearsem = params[:ysem]
	@pathname = params[:pname]
  end
  
end
