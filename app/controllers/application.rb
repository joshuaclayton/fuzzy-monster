# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  protect_from_forgery :secret => '022d61d4048fd5056baa11970b2747eb'

  filter_parameter_logging :password
end
