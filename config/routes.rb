ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'site'
  
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  
  map.with_options :controller => 'twitter' do |m|
    m.twitter 'twitter/create', :action => 'create'
    m.twitter_approve 'twitter/approve', :action => 'approve'
  end
  
  map.resources :users
  map.resource :session

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
