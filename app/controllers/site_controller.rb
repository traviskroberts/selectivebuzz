class SiteController < ApplicationController
  layout 'home'

  def index
    redirect_to my_account_path if logged_in?
    
    @user = User.new
  end

end
