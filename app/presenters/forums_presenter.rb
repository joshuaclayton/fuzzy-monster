class ForumsPresenter
  include Enumerable
  
  delegate :to_xml, :to => :@forums
  
  def initialize(options = {})
    options.assert_valid_keys(:forums, :current_user)
    @forums = options[:forums] || Forum.ordered
    @current_user = options[:current_user]
  end
  
  def can_be_created_by_current_user?
    !!(@current_user && @current_user.has_privilege?(:admin))
  end
  
  def each(&block)
    @forums.each(&block)
  end
end