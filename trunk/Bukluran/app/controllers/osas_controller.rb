require 'lib/pdfdrawer'

class OsasController < ApplicationController
  def index
    @user = Osa.find_by_account_id(session[:user_id])
    @announcements = Announcement.all
    @pending = Organization.all(:conditions => "status = 0")
  end
  
  def start_app
    @user = Osa.find(session[:user_id])
    Organization.update_all("status = -1")
    redirect_to 'osas'
  end
  
  def end_app
  end
  
  def new_app
    @user = Osa.find(session[:user_id])
    @newOrg = Organization.all(:conditions => "status = -1")
  end
  def app_show
    @user = Osa.find(session[:user_id])
    @orgdata = Organization.find(params[:id])
  end
  def show_only
	@user = Osa.find(session[:user_id])
	@orgdata = Organization.find(params[:id])
  end
  def new
	@user = Osa.find(session[:user_id])
  end
  def show_forms
    @user = Osa.find(session[:user_id])
    @orgdata = Organization.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        send_data PdfDrawer.draw(@orgdata), :filename => 'organization.pdf', :type => 'application/pdf', :disposition => 'inline'
      end
    end
  end
  def form1
    @user = Osa.find(session[:user_id])
    @orgdata = Organization.find(params[:id])
    #kapag papalitan ang db baka palitan natin yung conditions. flag lang. natagalan ako dahil sa errors ng SQL T_T
    @mt = Membership.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ?', 'm', @orgdata.id]).size
    @ft = Membership.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ?', 'f', @orgdata.id]).size
    @msop = Membership.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ? AND student_no <= ? AND student_no > ?', 'm', @orgdata.id, (Time.now.year)*100000, (Time.now.year-2)*100000]).size
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
  def form_awards
    @user = Osa.find(session[:user_id])
    @orgdata = Organization.find(params[:id])
  end
  def form_reports
    @user = Osa.find(session[:user_id])
    @orgdata = Organization.find(params[:id])
  end
  
  def create
    @organization = Organization.new(:name => params[:name])
    @organization.status = -1
    @account = Account.new(:username => params[:username], :password => params[:password], :id => params[:id], :group => 'ORGANIZATION')
    @organization.account = @account
    if @account.save and @organization.save
      flash[:notice] = "Successfully Created New Organization Account"
      redirect_to :controller => 'osas', :action => 'new_app'
    else
      render :action => "new_app"
    end 
  end
  
  def search_all_org(search_data)
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
    @organizations = search_all_org params[:name]
  end
  
  def showall
	@organization = Organization.find(:all)
  end

  def show
    @user = Osa.find(session[:user_id])
    @pending = Organization.all(:conditions => "status = 0")
    if @pending.empty?
      flash[:notice] = "No pending application"
    end
  end
  
  def approve
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
	@user = Osa.find(session[:user_id])
  end
  
end
