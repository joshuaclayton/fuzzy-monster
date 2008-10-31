CAMPFIRE_URL = "http://marshmallow@fusionary.com:toasted@jbaty.campfirenow.com/rooms/22379"

Capistrano.configuration(:must_exist).load do
  begin
    if using_passenger
      require File.dirname(__FILE__) +  '/passenger'
    else
      require 'mongrel_cluster/recipes'
    end
  rescue
    set :using_passenger, false
    require 'mongrel_cluster/recipes'
  end
  
  set :app_symlinks,  nil
  
  set :mongrel_port,    nil
  set(:mongrel_conf)  { "#{shared_path}/config/mongrel_cluster.yml" }
  set(:mongrel_user)  { user }
  set(:mongrel_group) { user }
  set :use_sudo,        false
  set :symlink_rails,   true
  set(:ferret_conf)   { "#{shared_path}/config/ferret_server.yml" }
  
  # Set rails_env to dev by default
  begin
    rails_env
  rescue NameError
    set :rails_env, 'development'
  end
  
  task :after_deploy do
    deploy.cleanup
    
    require File.dirname(__FILE__) + "/marshmallow"
    Marshmallow.say(CAMPFIRE_URL, "[DEPLOY] #{user} #{application} #{ENV["STAGE"]} by #{ENV['USER']} from r#{revision}")
  end
  
  namespace :deploy do  
    unless using_passenger    
      task :restart, :roles => :app do
        cmd  = "mongrel_rails cluster::restart -C #{mongrel_conf}"
        invoke_command cmd, :via => run_method
      end
    
      task :spinner, :roles => :app do
        cmd = "mongrel_rails cluster::restart -C #{mongrel_conf}"
        invoke_command cmd, :via => run_method
      end
    end
    
    task :before_restart, :roles => :app do
      web.disable
    end

    task :after_restart, :roles => :app do
      web.enable
      ferret.restart
    end
    
  end
  
  namespace :ferret do
    
    desc "Restart the ferret server"
    task :restart, :roles => :app do
      stop
      start
    end
    
    desc "Stop the ferret server"
    task :stop, :roles => :app do
      run <<-CMD
          if [ -e #{ferret_conf} ]; then
            cd #{current_path} && RAILS_ENV=#{rails_env} ./script/ferret_stop;
          fi
      CMD
    end
    
    desc "Start the ferret server"
    task :start, :roles => :app do
      run <<-CMD
          if [ -e #{ferret_conf} ]; then
            cd #{current_path} && RAILS_ENV=#{rails_env} ./script/ferret_start;
          fi
      CMD
    end
    
  end
  
  desc "Restart app with passenger"
  task :restart_passenger, :roles => :app do
    cmd = "touch #{current_path}/tmp/restart.txt"
    invoke_command cmd, :via => run_method
  end
  
  # Override start and restart mongrel cluster to clean pid files
  task :start_mongrel_cluster, :roles => :app do
    cmd = "mongrel_rails cluster::start -C #{mongrel_conf} --clean"
    invoke_command cmd, :via => run_method
  end
  
  task :restart_mongrel_cluster, :roles => :app do
    cmd = "mongrel_rails cluster::restart -C #{mongrel_conf} --clean"
    invoke_command cmd, :via => run_method
  end
  
  task :migrate_engines, :roles => :db, :only => { :primary => true } do
    run "cd #{current_path} && " +
        "#{rake} RAILS_ENV=#{rails_env} db:migrate:engines"
  end
  
  task :fix_home_dir_perms, :roles => [:app, :web] do 
    run "chmod 701 /home/#{user}"
    run "chmod -R 755 /home/#{user}/apps/#{application}"
  end
  
  task :after_setup, :roles => :app do
    run "mkdir -p #{shared_path}/config"
    mongrel.cluster.configure unless using_passenger
    setup_symlinks
    fix_home_dir_perms
  end
  
  task :after_update_code, :roles => [:web, :app, :db] do
    %w[database.yml mongrel_cluster.yml settings.yml gmaps_api_key.yml].each do |config_file|
      run "ln -nfs #{shared_path}/config/#{config_file} #{release_path}/config"
    end
  end
  
  task :setup_symlinks, :roles => [:app, :web] do
    if app_symlinks
      app_symlinks.each do |link|
        if link.split("/").last.include? "."
          run "mkdir -p #{shared_path}/#{File.dirname(link)}"
        else
          run "mkdir -p #{shared_path}/#{link}"
        end
      end
    end
  end
  
  task :symlink_extras, :roles => [:app, :web] do
    if app_symlinks
      app_symlinks.each { |link| run "ln -nfs #{shared_path}/#{link} #{current_path}/#{link}" }
    end
  end
  
  task :symlink_vendor_rails do
    if symlink_rails
      run "ln -nfs /usr/local/lib/rails #{current_path}/vendor/rails"
    end
  end

  task :after_symlink, :roles => [:app, :web] do
    symlink_vendor_rails
    symlink_extras
  end

  # UTILITY TASKS
  desc "remotely console"   
  task :console, :roles => :app do
    input = ''
    run "cd #{current_path} && ./script/console #{ENV['RAILS_ENV']}" do |channel, stream, data|
      next if data.chomp == input.chomp || data.chomp == ''
      print data
      channel.send_data(input = $stdin.gets) if data =~ /^(>|\?)>/
    end
  end
  
  desc "tail production log files" 
  task :tail_logs, :roles => :app do
    run "tail -f #{shared_path}/log/production.log" do |channel, stream, data|
      puts  # for an extra line break before the host name
      puts "#{channel[:host]}: #{data}" 
      break if stream == :err    
    end
  end
  
end
