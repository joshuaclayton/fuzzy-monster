require "factory_girl"

Factory.define :forum do |forum|
  forum.name "Test Forum"
end

Factory.define :topic do |topic|
  topic.title "Topic Title"
  topic.body "Body text"
  topic.association :forum
  topic.association :creator, :factory => :user
end

Factory.define :post do |post|
  post.body "Test post"
  post.association :author, :factory => :user
  post.topic {|p| p.association(:topic, :creator => p.author) }
end

Factory.define :user do |user|
  default_role = "user"
  default_privileges = ["has_account"]

  user.username { ActiveSupport::SecureRandom.hex(16) }
  user.first_name "John"
  user.last_name "Doe"
  user.password "password"
  user.password_confirmation "password"
  user.active true
  user.email_address { |u| "#{u.username}@test.com" }
  
  role = Role.find_or_create_by_name(default_role)
  privs = []
  default_privileges.each {|p| privs << Privilege.find_or_create_by_name(p) }
  
  role.privileges << privs
  user.role role
end