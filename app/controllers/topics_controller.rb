class TopicsController < ApplicationController
  resource_controller
  belongs_to :forum
  
  restrict_to :only => [:new, :create] do
    parent_object.can_topic_be_created_by_current_user?
  end
  
  restrict_to :only => [:edit, :update] do
    object.can_be_edited_by_current_user?
  end
  
  index.wants.html  { redirect_to parent_object }
  index.wants.xml   { render :xml => @topics }
  show.before       { object.view! }
  create.before     { object.creator = current_user }
  
  private
  
  def parent_object
    parent? && !parent_singleton? ? ForumPresenter.new(:forum => parent_model.find_by_slug!(parent_param), :current_user => current_user) : nil
  end
  
  def object
    @object ||= TopicPresenter.new(:topic => end_of_association_chain.find_by_slug!(param), :current_user => current_user)
  end
  
  def build_object
    @object ||= TopicPresenter.new(:topic => end_of_association_chain.send(parent? ? :build : :new, object_params), :current_user => current_user)
  end
end