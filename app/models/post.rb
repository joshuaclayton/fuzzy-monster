class Post < ActiveRecord::Base
  belongs_to :author, :class_name => "User", :foreign_key => :author_id, :counter_cache => true
  belongs_to :forum, :counter_cache => true
  belongs_to :topic, :counter_cache => true
  
  before_validation_on_create :set_forum_from_topic
  validate :topic_is_not_locked, :if => lambda {|post| post.topic && post.topic.posts_count > 0}
  validates_presence_of :author_id, :forum_id, :topic_id, :body
  
  delegate :name, :to => :forum, :prefix => true
  
  protected
  
  def set_forum_from_topic
    self.forum = self.topic.forum
  end
  
  def topic_is_not_locked
    errors.add(:topic_id, "is locked") if self.topic.locked?
  end
end