class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  
  protect_from_forgery :secret => '022d61d4048fd5056baa11970b2747eb'
  
  filter_parameter_logging :password
  
  before_filter :manage_page
  
  protected
  
  def manage_page
    @page_title = ["Fuzzy Monster"]
    @copyright_year = [2008, Time.now.year].uniq.join(" - ")
  end
end
