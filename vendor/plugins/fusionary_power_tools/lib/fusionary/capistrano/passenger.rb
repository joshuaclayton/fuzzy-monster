Capistrano::Configuration.instance.load do
  
  namespace :passenger do
    desc 'Restart passenger on the app server'
    task :restart, :roles => :app do
      cmd = "touch #{release_path}/tmp/restart.txt"
      invoke_command cmd, :via => run_method
    end
  end
  
  namespace :deploy do
    desc 'Restart passenger on the app server'
    task :restart, :roles => :app do
      passenger.restart
    end
  
    desc 'Start passenger on the app server (dummy task)'
    task :start, :roles => :app do; end
  
    desc 'Start passenger on the app server (dummy task)'
    task :stop, :roles => :app do; end
    
    task :spinner, :roles => :app do
      passenger.restart
    end
  end
end