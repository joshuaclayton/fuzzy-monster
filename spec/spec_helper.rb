# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
dir = File.expand_path(File.dirname(__FILE__))
require File.expand_path(dir + "/../config/environment")
require 'spec'
require 'spec/rails'

Dir[dir + "/spec_helpers/**/*.rb"].each { |f| require f }

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  def login_with(user_type = nil)
    mock_user = user_type.nil? ? Generate.user : Generate.send("#{user_type}_user")
    User.stub!(:current_user).and_return(mock_user)
  end
  
  def current_user
    User.current_user
  end
end
