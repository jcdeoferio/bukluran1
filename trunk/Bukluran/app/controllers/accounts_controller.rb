class AccountsController < ApplicationController
  def index
    @accounts = Account.find(:all)
  end

  def show
    @account = Account.find(params[:id])
  end

  def new
    @account = Account.new
  end
  
  def create
    @account = Account.new(params[:account])
    if @account.save
      flash[:notice] = "Successfully Created New Account"
      @owner = Organization.new
      case @account.group
      when 'OSA'
        @owner = Osa.create(:name => 'osa')
      when 'ADMINISTRATOR'
        @owner = Administrator.create(:name => 'admin')
      when 'ORGANIZATION'
        Organization.create(:name => 'new organization')
      end 
      @owner.account = @account
      @owner.save
      redirect_to :controller => 'accounts', :action => 'show', :id => @account.id
    else
      render :action => "new"
    end  
  end

  def edit
  end

  def destroy
    @account = Account.find(params[:id])
    flash[:notice] = "Successfully deleted " + @account.username
    @account.destroy
    redirect_to accounts_path
  end

end
