class ApplicationController < ActionController::Base
  BLUEPRINT_CONTENT_WIDTH = 24 unless defined?(BLUEPRINT_CONTENT_WIDTH)
  APPLICATION_NAME = "Fuzzy Monster"
  helper :all # include all helpers, all the time
  
  protect_from_forgery :secret => '022d61d4048fd5056baa11970b2747eb'
  
  filter_parameter_logging :password
  
  before_filter :manage_page
  
  protected
  
  def manage_page
    @page_title = [ApplicationController::APPLICATION_NAME]
    @copyright_year = [2008, Time.now.year].uniq.join(" - ")
  end
end
