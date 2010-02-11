require 'railsmachine/recipes'

# =============================================================================
# REQUIRED VARIABLES
# =============================================================================
# The name of your application.
set :application, "selectivebuzz"

# Target directory for the application on the web and app servers.
set :deploy_to, "/var/www/apps/#{application}"

# Primary domain name of your application. Used as a default for all server roles.
set :domain, "selectivebuzz.travisroberts.net"

# Login user for ssh.
set :user, "deploy"
set :runner, user
set :admin_runner, user

# Rails environment. Used by application setup tasks and migrate tasks.
set :rails_env, "production"

# =============================================================================
# ROLES
# =============================================================================
# Modify these values to execute tasks on a different server.
role :web, domain
role :app, domain
role :db,  domain, :primary => true
role :scm, domain

# =============================================================================
# APPLICATION SERVER OPTIONS
# ============================================================================= 
set :app_server, :passenger

# =============================================================================
# DATABASE OPTIONS
# =============================================================================
set :database, :mysql

# =============================================================================
# SCM OPTIONS
# =============================================================================
set :scm, :git
set :repository, 'git@github.com:travisr/selectivebuzz.git'

# =============================================================================
# CAPISTRANO OPTIONS
# =============================================================================
set :keep_releases, 3

# =============================================================================
# POST-DEPLOY TASKS
# =============================================================================
namespace :deploy do
  desc "Symlink database config file and twitter config file."
  task :symlinks do
    run "ln -nfs #{shared_path}/system/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/system/twitter.yml #{release_path}/config/twitter.yml"
  end
end

after 'deploy:update_code', 'deploy:symlinks'
