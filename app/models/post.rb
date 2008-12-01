module Posts
  module Callbacks
    def self.included(base)
      base.send :include, Posts::Callbacks::InstanceMethods
      base.before_validation_on_create :set_forum_from_topic
    end
    
    module InstanceMethods
      protected
      
      def set_forum_from_topic
        self.forum = self.topic.forum
      end
    end
  end
  module Validations
    def self.included(base)
      base.send :include, Posts::Validations::InstanceMethods
      base.validate :topic_is_not_locked, :if => lambda {|post| post.topic && post.topic.posts_count > 0}
      base.validates_presence_of :author_id, :forum_id, :topic_id, :body
    end
    
    module InstanceMethods
      protected
      
      def topic_is_not_locked
        errors.add(:topic_id, "is locked") if self.topic.locked?
      end
    end
  end
end

class Post < ActiveRecord::Base
  include Posts::Callbacks
  include Posts::Validations
  
  belongs_to :author, :class_name => "User", :foreign_key => :author_id, :counter_cache => true
  belongs_to :forum, :counter_cache => true
  belongs_to :topic, :counter_cache => true
  
  delegate :name, :to => :forum, :prefix => true
end