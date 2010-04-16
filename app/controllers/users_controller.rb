class UsersController < ApplicationController
  before_filter :login_required, :only => [:edit, :update, :show, :my_account]

  # render new.rhtml
  def new
    @user = User.new
    render :layout => 'home'
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash.now[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new', :layout => 'home'
    end
  end
  
  def edit
    @user = current_user
    render :layout => 'home'
  end
  
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:success] = 'Account updated.'
      redirect_to my_account_path
    else
      flash.now[:error] = 'Could not update account.'
      render :action => 'edit', :layout => 'home'
    end
  end
  
  def show
    redirect_to my_account_path
  end
  
  def my_account
    @user = current_user
    render :action => 'show'
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end
end
