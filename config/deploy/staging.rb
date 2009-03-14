#############################################################
#	Application
#############################################################

set :application, "meetinbetween-staging"
set :deploy_to, "/var/www/apps/meetinbetween"

#############################################################
#	Settings
#############################################################

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :use_sudo, true
set :scm_verbose, true
set :rails_env, "staging" 

#############################################################
#	Servers
#############################################################

set :user, "joe"
set :domain, "staging.meetinbetween.us"
server domain, :app, :web
role :db, domain, :primary => true

#############################################################
#	Git
#############################################################

set :scm, :git
set :branch, "master"
set :scm_user, 'faithfulgeek'
set :repository, "git@github.com:andrewkavanaugh/meetinbetweenus.git"

#############################################################
#	Passenger
#############################################################

namespace :deploy do
  desc "Create the database yaml file"
  task :create_database_config do
    #########################################################
    # Uncomment the following to symlink an uploads directory.
    # Just change the paths to whatever you need.
    #########################################################
    
    # desc "Symlink the upload directories"
    # task :before_symlink do
    #   run "mkdir -p #{shared_path}/uploads"
    #   run "ln -s #{shared_path}/uploads #{release_path}/public/uploads"
    # end
  end
  
  # Restart passenger on deploy
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
  
  desc "Create asset packages for production"
  task :after_update_code, :roles => [:web] do
    run <<-EOF
      cd #{release_path} && rake RAILS_ENV=production asset:packager:build_all
    EOF
    
    db_config = <<-EOF
staging:
  adapter: mysql
  username: root
  password: gr34tlakes!@
  database: meetinbetween
  host: localhost
EOF
    
    put db_config, "#{release_path}/config/database.yml"

  end
  
end
