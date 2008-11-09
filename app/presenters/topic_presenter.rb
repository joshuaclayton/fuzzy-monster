class TopicPresenter
  delegate :id, :class, :errors, :to_param, :new_record?, :respond_to?, :is_a?, :to => :@topic
  
  def initialize(options = {})
    options.assert_valid_keys(:topic, :current_user)
    @topic = options[:topic]
    @current_user = options[:current_user]
  end
  
  def can_be_edited_by_current_user?
    @topic.creator == @current_user
  end
  
  def can_be_locked_by_current_user?
    is_current_user_admin?
  end
  
  def can_be_stickied_by_current_user?
    is_current_user_admin?
  end
  
  def can_be_replied_to_by_current_user?
    !@topic.locked? && @current_user
  end
  
  def method_missing(call, *args)
    @topic.send call, *args
  end
  
  private
  
  def is_current_user_admin?
    !!(@current_user && @current_user.has_privilege?(:admin))
  end
end