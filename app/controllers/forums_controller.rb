class ForumsController < ApplicationController
  resource_controller
  
  index.wants.xml { render :xml => @forums }
  show.wants.xml { render :xml => @forum }
  
  private
  
  def collection
    @collection ||= end_of_association_chain.ordered
  end
        
  def object
    @object ||= end_of_association_chain.find_by_slug!(param)
  end
end
