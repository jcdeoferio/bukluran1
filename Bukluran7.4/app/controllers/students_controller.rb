class StudentsController < ApplicationController
  def index
  end

  def confirm
    @member = Member.find_by_id(params[:id])
	@member.confirm = true
	@member.save
	flash[:notice] = "Confirmation Successful"
	redirect_to "profile/#{student.id}"
  end

  def profile
    @student = Member.find_by_confirmation_key(params[:id]).student
    if @student
      @members = @student.members
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
