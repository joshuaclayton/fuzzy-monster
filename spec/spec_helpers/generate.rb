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
      :role       => "admin",
      :privilege  => "admin"
    }))
  end
  
  def self.user(attributes = {})
    key = ActiveSupport::SecureRandom.hex(16)
    
    user = User.new(attributes.reverse_merge({
      :first_name             => "John",
      :last_name              => "Doe",
      :password               => "password",
      :password_confirmation  => "password",
      :active                 => true,
      :username               => key,
      :email_address          => "#{key}@test.com"
    }))
    
    default_privileges = (["has_account"] << attributes.delete(:privileges)).compact.uniq
    role = Role.find_or_create_by_name(attributes.delete(:role) || "user")
    
    privs = []
    default_privileges.each {|p| privs << Privilege.find_or_create_by_name(p)}
    
    user.role = role
    role.privileges << privs
    
    user.save!
    user
  end
  
  def self.topic(attributes = {})
    topic = Topic.new(attributes.reverse_merge({
      :body     => "Body text",
      :forum    => Generate.forum,
      :creator  => Generate.user,
      :title    => "Random Title"
    }))
    topic.save!
    topic
  end
  
  def self.post(attributes = {})
    post = Post.new(attributes.reverse_merge({
      :body   => "Test post",
      :author => (author = Generate.user),
      :topic  => Generate.topic(:creator => author)
    }))
    post.save!
    post
  end
end