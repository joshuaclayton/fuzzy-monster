class Forum < ActiveRecord::Base
  acts_as_list
  
  has_permalink :name, :slug
  
  named_scope :ordered, {:order => "#{Forum.table_name}.position ASC"}
  
  has_many :topics, :order => "#{Topic.table_name}.sticky DESC, #{Topic.table_name}.last_updated_at DESC", :dependent => :destroy
  
  validates_presence_of :name
  
  def to_param
    self.slug
  end
  
  def self.reorder(array_of_ids)
    array_of_ids.each_with_index do |id, index|
      forum = self.find(id) rescue nil
      forum.update_attribute(:position, index + 1) if forum
    end
  end
end
