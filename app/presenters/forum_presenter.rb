class ForumPresenter
  delegate :id, :class, :errors, :to_param, :new_record?, :respond_to?, :is_a?, :to => :@forum
  
  def initialize(options = {})
    options.assert_valid_keys(:forum, :current_user)
    @forum = options[:forum]
    @current_user = options[:current_user]
  end
  
  def can_be_edited_by_current_user?
    !!(@current_user && @current_user.has_privilege?(:admin))
  end
  
  def can_be_deleted_by_current_user?
    false
  end
  
  def can_topic_be_created_by_current_user?
    !!(@current_user && @current_user.has_privilege?(:has_account))
  end
  
  def method_missing(call, *args)
    @forum.send call, *args
  end
end