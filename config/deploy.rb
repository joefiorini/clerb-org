set :application, "clerb.org"
set :repository,  "git://git.densitypop.net/clerb.git"
set :scm, :git
set :git_enable_submodules, 1
set :spinner_user, nil
set :runner, 'deployer'

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/web/#{application}"

role :app, "densitypop.net"
role :web, "densitypop.net"
role :db,  "densitypop.net", :primary => :true
