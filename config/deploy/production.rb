#############################################################
#  Application
#############################################################

set :application, "clerb.org"
set :deploy_to, "/var/www/apps/clerb.org"

#############################################################
#  Settings
#############################################################

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :use_sudo, true
set :scm_verbose, true
set :rails_env, "production"

#############################################################
#  Servers
#############################################################

set :user, "joe"
set :domain, "72.14.182.251"
server domain, :app, :web
role :db, domain, :primary => true

#############################################################
#  Git
#############################################################

set :scm, :git
set :branch, "master"
set :scm_user, 'faithfulgeek'
set :repository, "git://github.com/faithfulgeek/clerb-org.git"
#set :deploy_via, :remote_cache

#############################################################
#  Passenger
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

  desc "Create production database config"
  task :after_update_code, :roles => [:web] do
    db_config = <<-EOF
production:
  adapter: mysql
  username: root
  password: gr34tlakes!@
  database: clerb
  host: localhost
EOF

    put db_config, "#{release_path}/config/database.yml"

  end

end
