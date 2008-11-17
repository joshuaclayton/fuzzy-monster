class Topic < ActiveRecord::Base
  has_permalink :title, :slug, :scope => :forum_id
  
  named_scope :sticky, { :conditions => {:sticky => true} }
  named_scope :not_sticky, { :conditions => {:sticky => false}}
  
  belongs_to  :forum, :counter_cache => true
  belongs_to  :creator, :class_name => "User", :foreign_key => :creator_id

  has_many    :posts, :order => "#{Post.table_name}.created_at", :dependent => :delete_all
  
  belongs_to  :last_post, :class_name => "Post", :foreign_key => :last_post_id
  belongs_to  :last_user, :class_name => "User", :foreign_key => :last_user_id
  
  validates_presence_of :title, :creator_id, :forum_id
  validates_presence_of :body, :on => :create
  
  after_create :create_initial_post
  
  attr_accessible :title, :body, :forum, :creator, :sticky, :locked
  
  attr_accessor :body
  
  def view!
    self.class.increment_counter :hits, self.id
  end
  
  def to_param
    self.slug
  end
  
  protected
  
  def create_initial_post
    self.posts.create(:author => self.creator, :body => self.body)
  end
end
