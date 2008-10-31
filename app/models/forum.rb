class Forum < ActiveRecord::Base
  acts_as_list
  has_permalink :name, :slug
  
  named_scope :ordered, {:order => "position ASC"}
  
  validates_presence_of :name
  
  def to_param
    self.slug
  end
end
