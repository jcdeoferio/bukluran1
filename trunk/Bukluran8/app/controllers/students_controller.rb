class StudentsController < ApplicationController
  def index
  end

  def confirm
    @member = Member.find_by_confirmation_key(params[:id])
    if @member
      if @member.confirm?
        flash[:notice] = "You have already confirmed your membership to this organization."
        redirect_to :controller => 'students', :action => "conof"
      else
        @member.update_attribute('confirm', true)
    	flash[:notice] = "Successfully confirmed membership"
    	redirect_to "/students/profile/#{params[:id]}"
      end
	else
	 flash[:error] = "INVALID REQUEST"
     redirect_to "/"
    end
  end
  
  def conof
  end
  
  def unconfirm
    @member = Member.find_by_confirmation_key(params[:id])
    if @member
	 @member.confirm = false
	 @member.save
	 flash[:notice] = "Membership Rejected"
	 redirect_to "/students/profile/#{params[:id]}"
	else
	 flash[:error] = "INVALID REQUEST"
     redirect_to "/"
	end
  end

  def profile
    @member = Member.find(params[:id])
    if @member
      @student = @member.student
      if @student
        @members = @student.members
        session[:confirm] = @member.confirmation_key
      else
        flash[:error] = "INVALID REQUEST"
        redirect_to "/"
      end
    else
      flash[:error] = "INVALID REQUEST"
      redirect_to "/"
    end
  end

  def update
    @student = Student.find(params[:id])
	
	#
	# [@student.title, @student.nickname, @student.name, @student.college, @student.gender, @student.degree_program, @student.contact_no, @student.permanent_address, @student.present_address, @student.guardian, @student.guardian_telno, @student.guardian_address].each do |f|
    #  f.strip!
    #end
    #@profile_completeness = @student.title != "" and @student.nickname != "" and @student.name != "" and @student.college != "" and @student.gender != "" and @student.degree_program != "" and @student.contact_no != "" and ( @student.present_address != "" or @student.permanent_address != "" or @student.guardian != "" or @student.guardian_telno != "" ) and @student.guardian_address != ""
 
    if @student.update_attributes(params[:student])
      flash[:notice] = "Profile has been updated!"
      redirect_to :controller => "students", :action => "conof"
    else
      flash[:error] = "INVALID REQUEST"
      redirect_to "/"
    end
  end
end
