class User < ActiveRecord::Base
  acts_as_login_model
  
  validates_uniqueness_of :username, :case_sensitive => false
  
  def full_name
    (self.first_name.blank? || self.last_name.blank?) ? self.username : "#{self.first_name} #{self.last_name}"
  end
end
