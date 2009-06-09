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
    @student = Student.find_by_id(params[:id])
    @members = @student.members
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
