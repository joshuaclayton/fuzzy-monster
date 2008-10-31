module ActionView
  module Partials
    private
    
    def render_partial_with_blueprint(*args)
      path = args.first[:partial]
      locals = args.last
      
      blueprint_cached_widths = session[:blueprint_cached_widths] ||= {}
      
      if blueprint_cached_widths.keys.include?(path)
        @blueprint_grid_width = locals[:blueprint_width] || blueprint_cached_widths[path]
        blueprint_cached_widths[path] = @blueprint_grid_width
      else
        blueprint_cached_widths[path] = @blueprint_grid_width if @blueprint_grid_width.is_a?(Fixnum) && path !~ /^layout/
      end
      
      render_partial_without_blueprint(*args)
    end
    
    alias_method_chain :render_partial, :blueprint
  end
end

module BlueprintCaching
  def self.included(base)
    base.send :include, BlueprintCaching::InstanceMethods
    base.before_filter :clear_blueprint_cache
  end
  
  module InstanceMethods
    def clear_blueprint_cache
      session[:blueprint_cached_widths] = nil unless request.xhr?
    end
  end
end

ActionController::Base.send :include, BlueprintCaching