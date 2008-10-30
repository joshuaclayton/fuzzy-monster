require 'pacecar/boolean'
require 'pacecar/datetime'
require 'pacecar/duration'
require 'pacecar/helpers'
require 'pacecar/limit'
require 'pacecar/order'
require 'pacecar/polymorph'
require 'pacecar/presence'
require 'pacecar/ranking'
require 'pacecar/search'
require 'pacecar/state'

module Pacecar
  def self.included(base)
    base.class_eval do
      extend ClassMethods
      class << self
        alias_method_chain :inherited, :define_scopes
      end
    end
  end

  module ClassMethods

    protected

    def inherited_with_define_scopes(child)
      inherited_without_define_scopes(child)
      child.class_eval do
        include Pacecar::Helpers
        include Pacecar::Boolean
        include Pacecar::Datetime
        include Pacecar::Duration
        include Pacecar::Limit
        include Pacecar::Order
        include Pacecar::Polymorph
        include Pacecar::Presence
        include Pacecar::Ranking
        include Pacecar::Search
        include Pacecar::State
      end
    end

  end
end

ActiveRecord::Base.send :include, Pacecar
