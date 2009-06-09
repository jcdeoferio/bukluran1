class StudentsController < ApplicationController
  def index
  end

  def confirm
    @member = Member.find_by_confirmation_key(params[:id])
    if @member
	 @member.confirm = true
	 @member.save
	 flash[:notice] = "Confirmation Successful"
	 redirect_to "/students/profile/#{params[:id]}"
	else
	 flash[:error] = "INVALID REQUEST"
     redirect_to "/"
	end
  end

  def profile
    @member = Member.find_by_confirmation_key(params[:id])
    @key = params[:id]
    if @member
      @student = @member.student
      if @student
        params[:id] = @student.id
        @members = @student.members
      else
       
      end
    else
      flash[:error] = "INVALID REQUEST"
      redirect_to "/"
    end
  end

  def update
    @student = Student.find_by_id(params[:id])
    if @student.update_attributes(params[:student])
      flash[:notice] = "Profile has been updated!"
      redirect_to :controller => "students", :action => "profile", :id => @student.id
    else
      flash[:error] = "INVALID REQUEST"
      redirect_to "/"
    end
  end
end
