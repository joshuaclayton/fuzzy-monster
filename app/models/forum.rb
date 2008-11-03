class Forum < ActiveRecord::Base
  acts_as_list
  has_permalink :name, :slug
  
  named_scope :ordered, {:order => "#{Forum.table_name}.position ASC"}
  
  has_many :topics, :order => "#{Topic.table_name}.sticky DESC, #{Topic.table_name}.last_updated_at DESC", :dependent => :delete_all
  
  validates_presence_of :name
  
  def to_param
    self.slug
  end
end
