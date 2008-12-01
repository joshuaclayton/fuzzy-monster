module Topics
  module Callbacks
    def self.included(base)
      base.send :include, Topics::Callbacks::InstanceMethods
      base.after_create :create_initial_post
    end
    
    module InstanceMethods
      protected
      def create_initial_post
        self.posts.create(:author => self.creator, :body => self.body)
      end
    end
  end
  module Validations
    def self.included(base)
      base.validates_presence_of :title, :creator_id, :forum_id
      base.validates_presence_of :body, :on => :create
    end
  end
  module NamedScopes
    def self.included(base)
      base.named_scope :sticky, { :conditions => {:sticky => true} }
      base.named_scope :not_sticky, { :conditions => {:sticky => false} }
    end
  end
end

class Topic < ActiveRecord::Base
  include Topics::Callbacks
  include Topics::Validations
  include Topics::NamedScopes
  
  has_permalink :title, :slug, :scope => :forum_id
  
  belongs_to  :forum, :counter_cache => true
  belongs_to  :creator, :class_name => "User", :foreign_key => :creator_id

  has_many    :posts, :order => "#{Post.table_name}.created_at", :dependent => :delete_all
  
  belongs_to  :last_post, :class_name => "Post", :foreign_key => :last_post_id
  belongs_to  :last_user, :class_name => "User", :foreign_key => :last_user_id
  
  attr_accessible :title, :body, :forum, :creator, :sticky, :locked
  attr_accessor :body
  
  def view!
    self.class.increment_counter :hits, self.id
  end
  
  def to_param
    self.slug
  end
end
