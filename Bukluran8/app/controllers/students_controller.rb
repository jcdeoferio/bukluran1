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
    if @student.update_attributes(params[:student])
      flash[:notice] = "Profile has been updated!"
      redirect_to :controller => "students", :action => "conof"
    else
      flash[:error] = "INVALID REQUEST"
      redirect_to "/"
    end
  end
end
