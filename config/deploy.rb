require 'capistrano_colors'
require "bundler/capistrano"

load 'deploy/assets'

set :application, "app"
set :repository,  "git@github.com:ogawakeisuke/soxtest.git"
set :scm, :git
set :branch, "master"

set :rails_env, "production"
set :user, 'soxtest'
set :use_sudo, false

set :deploy_to, "/home/soxtest/#{application}"

#ここらの情報はRAILS_ENVに応じて変わってくることが多いので本来はdeploy/に個別に設定する

set :scm_verbose, true
default_run_options[:pty] = true
ssh_options[:forward_agent] = true


set :bundle_gemfile, "Gemfile" #バンドル系
set :bundle_cmd, "bundle"
set :bundle_roles, [:app]

set :git_shallow_clone, 1

web_1 = "ec2-54-248-69-180.ap-northeast-1.compute.amazonaws.com"
web_2 = "ec2-54-249-148-101.ap-northeast-1.compute.amazonaws.com"

role :web, "#{web_1}", "#{web_2}"                          # Your HTTP server, Apache/etc
role :app, "#{web_1}"                          # This may be the same as your `Web` server
role :db,  "#{web_1}", :primary => true # This is where Rails migrations will run

set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "/home/soxtest/app/shared/pids/unicorn.pid"


#sqlite対策
task :db_setup, :roles => [:db] do
  run "mkdir -p -m 775 #{shared_path}/db"
end


#unicornスタート設定　完コピ
namespace :deploy do
  task :start, :roles => :web do 
    run "cd #{current_path} && bundle exec unicorn_rails -c #{unicorn_config} -E #{rails_env} -D"
  end
  task :stop, :roles => :web do 
    run "if test -f #{unicorn_pid};then kill `cat #{unicorn_pid}`; fi"
  end
  task :restart, :roles => :web do
    stop
    start
  end
#  task :symlink_static do
#    print "    creating symlink /var/www/#{application}/ -> #{current_path}/public.\n"
#    run "ln -s #{current_path}/public /var/www/#{application}"
#  end
end



# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end