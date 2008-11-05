class PostsController < ApplicationController
  resource_controller
  belongs_to :topic
  
  create.before     { object.author = current_user }
  create.wants.html { redirect_to [parent_object.forum, parent_object] }
  
  private
  
  def parent_object
    parent? && !parent_singleton? ? TopicPresenter.new(:topic => parent_model.find_by_slug!(parent_param), :current_user => current_user) : nil
  end
  
  def object
    @object ||= end_of_association_chain.find_by_slug!(param)
  end
  
  def build_object
    @object ||= end_of_association_chain.send(parent? ? :build : :new, object_params)
  end
end
