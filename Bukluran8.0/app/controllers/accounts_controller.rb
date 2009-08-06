class AccountsController < ApplicationController
  def index
    @accounts = Account.all
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
      @owner = nil
      case @account.group
        when 'OSA'
          @owner = Osa.create(:coordinator => 'osa')
        when 'ORGANIZATION'
          @owner = Organization.create(:name => 'new organization', :status => 'Not Renewed')
      end
      @owner.account = @account
      @owner.save
      redirect_to :controler => 'accounts', :action => 'show', :id => @account.id
    else
      render :action => 'new'
    end         
  end
  
  def destroy
    @account = Account.find(params[:id])
    flash[:notice] = "Successfully deleted " + @account.username
    @account.destroy
    redirect_to accounts_path
  end

end
