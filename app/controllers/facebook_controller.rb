class FacebookController < ApplicationController
  
  before_filter :ensure_authenticated_to_facebook
  
  def create
    redirect_to my_account_path
  end

  def approve
    current_user.update_attributes({:facebook_enabled => true, :facebook_uid => @facebook_session.user.uid})
    redirect_to my_account_path
  end

end
