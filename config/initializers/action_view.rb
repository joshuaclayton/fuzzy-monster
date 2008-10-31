module ActionView
  module Helpers
    # titleize after humanize text
    class InstanceTag
      def to_label_tag(text = nil, options = {})
        options = options.stringify_keys
        name_and_id = options.dup
        add_default_name_and_id(name_and_id)
        options.delete("index")
        options["for"] ||= name_and_id["id"]
        content = (text.blank? ? nil : text.to_s) || method_name.humanize.titleize
        label_tag(name_and_id["id"], content, options)
      end
    end
    
    class FormBuilder
      def show_required
        @options[:show_required] = true
      end
      
      def label(method, text = nil, options = {})
        if @options[:show_required]
          mod = @object_name.to_s.classify.constantize
          new_mod = mod.new
          new_mod.valid?
          error_fields = get_error_attrs_for(new_mod)
          assoc_error_fields = error_fields.map {|f| get_error_attrs_for(new_mod.send(f)) if mod.reflect_on_association(f) }.flatten
          error_fields += assoc_error_fields
          css_class = [options[:class] || ""]
          css_class << "required" if error_fields.include?(method.to_sym)
          options[:class] = css_class.find_all {|c| !c.blank? }.join(" ")
        end
        @template.label(@object_name, method, text, objectify_options(options))
      end
      
      private
      
      def get_error_attrs_for(model)
        model.errors.instance_variable_get("@errors").keys.map(&:to_sym)
      end
    end
  end
end