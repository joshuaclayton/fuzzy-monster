#### This is the mega-cool bootstrapping task.
# 
# Run this task after you check out an application from the SCM 
#
# Environment Variables:
#
# DESTRUCTIVE="true" - Drop and recreate the dev and test databases.
# MYSQL="<your mysql command>" - override mysql command detection (probably required for MacPorts mysql).

has_specs = File.exists?(File.join(RAILS_ROOT, 'spec'))

desc "Bootstrap the whole she-bang"
task :bootstrap do
  
  Rake::Task["bootstrap:config:check"].invoke
  Rake::Task["bootstrap:config:process"].invoke
  
  begin
    Rake::Task["environment"].invoke
    ActiveRecord::Base.establish_connection(:development)
    unless ActiveRecord::Base.connection
      raise "Could not connect to your development database. Please check the database.yml file and verify that the database exists."
    end
  rescue
  end
  
  Rake::Task["log:clear"].invoke
  Rake::Task["tmp:clear"].invoke
  Rake::Task["bootstrap:db:create"].invoke if ENV['DESTRUCTIVE'] == "true"

  ActiveRecord::Base.establish_connection(:development)
  
  Rake::Task["db:migrate"].invoke

  puts '## LOADING FIXTURES'
  Rake::Task["bootstrap:db:load_fixtures"].invoke

  puts '## CLONING DB STRUCTURE TO TEST'
  ActiveRecord::Base.establish_connection(:test)
  puts '#### CONNECTION ESTABLISHED'
  Rake::Task["db:test:clone"].invoke
  
  if has_specs
    puts '#### Running specs'
    Rake::Task["spec"].invoke
  end

  puts '#### ...DONE'

end

namespace :bootstrap do
  namespace :db do
    
    desc "Empty the development database"
    task :purge => :environment do
      abcs = ActiveRecord::Base.configurations
      case abcs["development"]["adapter"]
        when "mysql"
          ActiveRecord::Base.establish_connection(:development)
          ActiveRecord::Base.connection.recreate_database(abcs["development"]["database"])
        when "postgresql"
          ENV['PGHOST']     = abcs["development"]["host"] if abcs["development"]["host"]
          ENV['PGPORT']     = abcs["development"]["port"].to_s if abcs["development"]["port"]
          ENV['PGPASSWORD'] = abcs["development"]["password"].to_s if abcs["development"]["password"]
          enc_option = "-E #{abcs["development"]["encoding"]}" if abcs["development"]["encoding"]
          `dropdb -U "#{abcs["development"]["username"]}" #{abcs["development"]["database"]}`
          `createdb #{enc_option} -U "#{abcs["development"]["username"]}" #{abcs["development"]["database"]}`
        when "sqlite","sqlite3"
          dbfile = abcs["development"]["database"] || abcs["development"]["dbfile"]
          File.delete(dbfile) if File.exist?(dbfile)
        when "sqlserver"
          dropfkscript = "#{abcs["development"]["host"]}.#{abcs["development"]["database"]}.DP1".gsub(/\\/,'-')
          `osql -E -S #{abcs["development"]["host"]} -d #{abcs["development"]["database"]} -i db\\#{dropfkscript}`
          `osql -E -S #{abcs["development"]["host"]} -d #{abcs["development"]["database"]} -i db\\#{RAILS_ENV}_structure.sql`
        when "oci"
          ActiveRecord::Base.establish_connection(:development)
          ActiveRecord::Base.connection.structure_drop.split(";\n\n").each do |ddl|
            ActiveRecord::Base.connection.execute(ddl)
          end
        else
          raise "Task not supported by '#{abcs["development"]["adapter"]}'"
      end
    end
    
    
    desc "Create development and testing databases"
    task :create => :environment do
      mysql_cmd = ENV['MYSQL'] || `which mysql`
      abcs = ActiveRecord::Base.configurations
      dbs = ["development", "test"]

      for db in dbs
        if (abcs[db]["host"].nil? or ["127.0.0.1", "localhost"].include?(abcs[db]["host"])) and (abcs[db]["adapter"] == "mysql")
          `echo 'DROP DATABASE #{abcs[db]["database"]};' | #{mysql_cmd} -h localhost -u #{abcs[db]["username"]}`
          `echo 'CREATE DATABASE #{abcs[db]["database"]};' | #{mysql_cmd} -h localhost -u #{abcs[db]["username"]}`
        end
     end
    end
    
    desc "Use Test::Unit or Rspec fixtures depending on if rspec is installed or not"
    task :load_fixtures do
      run = "db:fixtures:load"
      run = "spec:" + run if has_specs
      Rake::Task[run].invoke
    end
    
  end
  
  namespace :config do
    desc "Check for database.yml"
    task :check do
      raise "database.yml not found. Please create one" unless 
      File.exist?(File.join(RAILS_ROOT, 'config', 'database.yml'))
    end
    
    desc "Process bootstrap.yml (See bootstrap.rake in fusionary_power_tools)"
    task :process do
      require 'rubygems'
      bootstrap_cfg = File.join(RAILS_ROOT, 'config', 'bootstrap.yml')
      if File.exist?(bootstrap_cfg)
        config = open(bootstrap_cfg) { |f| YAML.load(f.read) }
        
        if config["filesystem"]
          (config["filesystem"]["create"] || []).each do |dir|
            fspath = File.join(RAILS_ROOT, dir)
            FileUtils.mkdir_p(fspath) unless File.exists?(fspath)
          end
          (config["filesystem"]["verify"] || []).each do |dir|
            fspath = File.join(RAILS_ROOT, dir)
            raise "Required directory does not exist: #{fspath}" unless File.exists?(fspath)
          end
        end
        
        config["gems"] ||= {}
        missing_gems = config["gems"].inject([]) do |arr, (name, version)|
          begin
            if version 
              gem name, version
            else
              gem name
            end
          rescue Gem::LoadError
            arr << [name, version]
          end
          arr
        end
        
        # Print out missing gems and attempt install
        unless missing_gems.empty?
          print "Missing the following required gems:\n"
          missing_gems.each do |missing|
            missing.compact!
            print missing.join(' '), "\n"
            print "Install now? (sudo access required) [Y/n]"
            unless STDIN.gets.chomp.upcase == 'N'
              install_cmd = "sudo gem install #{missing.first}"
              install_cmd += " -v #{missing.last}" if missing.size > 1
              sh install_cmd
            end
          end
        end
      end
    end
    
  end
  
  
end