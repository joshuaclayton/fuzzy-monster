class Generate
  def self.forum(attributes = {})
    forum = Forum.new(attributes.reverse_merge({
      :name => "Test Forum"
    }))
    forum.save!
    forum
  end
  
  def self.admin_user(attributes = {})
    Generate.user(attributes.reverse_merge({
      :role => "admin",
      :privilege => "admin"
    }))
  end
  
  def self.user(attributes = {})
    default_role = attributes.delete(:role) || "user"
    default_privileges = (["has_account"] << attributes.delete(:privilege)).compact.uniq
    key = ActiveSupport::SecureRandom.hex(16)
    
    user = User.new(attributes.reverse_merge({
      :first_name => "John",
      :last_name => "Doe",
      :password => "password",
      :password_confirmation => "password",
      :active => true,
      :username => key,
      :email_address => "#{key}@test.com"}))
    role = Role.find_or_create_by_name(default_role)
    privs = []
    default_privileges.each {|p| privs << Privilege.find_or_create_by_name(p)}
    
    role.privileges << privs
    user.role = role
    user.save!
    user
  end
  
  def self.topic(attributes = {})
    topic = Topic.new(attributes.reverse_merge({
      :forum => Generate.forum,
      :creator => Generate.user,
      :title => "Random Title"
    }))
    topic.save!
    topic
  end
end