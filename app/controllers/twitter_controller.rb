class TwitterController < ApplicationController
  
  before_filter :login_required, :oauth
  
  def create
    @oauth.set_callback_url(twitter_approve_url)
    
    session['rtoken']  = oauth.request_token.token
    session['rsecret'] = oauth.request_token.secret
    
    redirect_to oauth.request_token.authorize_url
  end

  def approve
    oauth.authorize_from_request(session['rtoken'], session['rsecret'], params[:oauth_verifier])
    
    session['rtoken']  = nil
    session['rsecret'] = nil
    
    profile = Twitter::Base.new(oauth).verify_credentials
    
    current_user.update_attributes({
      :twitter_enabled => true,
      :twitter_name => profile.screen_name,
      :twitter_token => oauth.access_token.token, 
      :twitter_secret => oauth.access_token.secret,
    })
    
    redirect_to user_path(current_user)
    
  end
  
  private
    def oauth
      @oauth ||= Twitter::OAuth.new(TwitterCredentials['token'], TwitterCredentials['secret'], :sign_in => true)
    end
end
