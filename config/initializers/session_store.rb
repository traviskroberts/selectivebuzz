# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_buzzbin_session',
  :secret      => '52165981c4436c605b465d984723b7e96beaee4826f3486e794bd702cbe4ff44de54038b62f394d05a656af136ee7018fa7b59a9b2d57097d3df42b8cbd72f26'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
