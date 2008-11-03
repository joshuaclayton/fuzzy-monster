class Topic < ActiveRecord::Base
  has_permalink :title, :slug, :scope => :forum_id
  
  named_scope :sticky, { :conditions => {:sticky => true} }
  
  belongs_to :forum, :counter_cache => true
  belongs_to :creator, :class_name => "User", :foreign_key => :creator_id
  
  validates_presence_of :title
  
  def view!
    self.class.increment_counter :hits, self.id
  end
  
  def to_param
    self.slug
  end
end
