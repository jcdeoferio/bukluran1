class MembersController < ApplicationController
  before_filter :login_required  
  def create
    @current_user = Organization.find_by_account_id session[:user_id]
    @status = @current_user.status
    @editable = @current_user.editable
    @year = Time.now.year
	if Time.now.month >4 && Time.now.month <11
	  @schoolyear = "#{@year.to_s} - #{(@year+1).to_s}"
	  @sem = "1st Semester"
	else
	  @schoolyear = "#{(@year-1).to_s} - #{@year.to_s}"
	  @sem = "2nd Semester"
	end
	
	@member = @current_user.members.new(:student_id => params[:id], :position => params[:position].upcase!, :year => @schoolyear)
	if params[:from] == 'form4'
	  @member.position = 'MEMBER'
    end
    
    @member_student = @current_user.members.collect {|f| [f.student.webmail, f.student.student_no] }.flatten
    
	if @member_student.member? @member.student.student_no or @member_student.member? @member.student.webmail
	  flash[:error] = "Student no. and/or webmail is already in the list (form3/form4)."
	  redirect_to :controller => 'members', :action => params[:from]
	else
	  if params[:position] != nil and params[:position] != ""
  	    if @member.save
  	      if params[:from] == 'form3'
    	      flash[:notice] = "Successfully added new officer."
  	      else
       	      flash[:notice] = "Successfully added new member."
  	      end
  	      redirect_to :controller => 'members', :action => params[:from]
  	    else
  	      flash[:error] = "Error encountered while saving new member. Try again."
  	      redirect_to :controller => 'members', :action => params[:from]
  	    end
      else
        flash[:error] = "You must fill in all of the fields."
        redirect_to :controller => 'members', :action => params[:from]
      end
	end
  end
  
  def create_form3
    @student = Student.new(:student_no => params[:student][:student_no], :webmail => params[:student][:webmail]+"@up.edu.ph")
    unless Student.find_by_student_no_and_webmail(@student.student_no, @student.webmail)
      if @student.student_no != nil and params[:student][:position] != nil and params[:student][:position].strip != ""      
        unless @student.save          
          flash[:error] = "Error encountered while saving new student. Try agian."
          redirect_to :controller => 'members', :action => 'form3'
        else
          redirect_to :controller => 'members', :action => 'create', :id => @student.id, :position => params[:student][:position].strip, :from => 'form3'
        end
      else
        flash[:error] = "You must fill in all of the fields."
        redirect_to :controller => 'members', :action => 'form3'
      end
    else
      redirect_to :controller => 'members', :action => 'create', :id => Student.find_by_student_no_and_webmail(@student.student_no, @student.webmail).id, :position => params[:student][:position].strip, :from => 'form3'
    end
  end
  
  def create_form4
    @student = Student.new(:student_no => params[:student][:student_no], :webmail => params[:student][:webmail]+"@up.edu.ph")
    unless Student.find_by_student_no_and_webmail(@student.student_no, @student.webmail)
      if @student.student_no != nil and params[:student][:position] != nil and params[:student][:position].strip != ""
        unless @student.save          
          flash[:error] = "Error encountered while saving new student. Try agian."
          redirect_to :controller => 'members', :action => 'form4'
        else
          redirect_to :controller => 'members', :action => 'create', :id => @student.id, :position => params[:student][:position], :from => 'form4'
        end
      else
        flash[:error] = "You must fill in all of the fields."
        redirect_to :controller => 'members', :action => 'form4'
      end
    else
      redirect_to :controller => 'members', :action => 'create', :id => Student.find_by_student_no_and_webmail(@student.student_no, @student.webmail).id, :position => params[:student][:position], :from => 'form4'
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
    @status = @current_user.editable
    
    if @status
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

end