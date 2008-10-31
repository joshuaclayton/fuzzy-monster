class ForumsController < ApplicationController
  resource_controller
  
  restrict_to :only => [:new, :create] do
    ForumsPresenter.new(:current_user => current_user).can_be_created_by_current_user?
  end
  
  restrict_to :only => [:edit, :update] do
    object.can_be_edited_by_current_user?
  end
  
  restrict_to :only => [:destroy] do
    object.can_be_deleted_by_current_user?
  end
  
  index.wants.xml { render :xml => @forums }
  show.wants.xml { render :xml => @forum }
  
  private
  
  def collection
    @collection ||= ForumsPresenter.new(:forums => end_of_association_chain.ordered, :current_user => current_user)
  end
  
  def object
    @object ||= ForumPresenter.new(:forum => end_of_association_chain.find_by_slug!(param), :current_user => current_user)
  end
  
  def build_object
    @object ||= ForumPresenter.new(:forum => end_of_association_chain.send(parent? ? :build : :new, object_params), :current_user => current_user)
  end
end
