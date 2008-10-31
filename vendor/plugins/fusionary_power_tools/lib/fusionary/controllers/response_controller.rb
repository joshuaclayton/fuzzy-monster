module Fusionary
  module Controllers
    module ResponseController
      protected
      
      def handle_generic(model, options = {})
        options[:action] ||= self.action_name.to_s
        respond_to do |format|
          handle_response_base self, format, options do |response|
            response.generate_custom_flash
            response.handle(:html, response.render_action)
            response.handle(:xml, response.render_xml(model))
            response.handle(:js, :if => response.responses[:js])
            response.handle(:pdf, :if => response.responses[:pdf])
            
            (response.responses.keys - [:html, :xml, :js, :pdf]).each do |resp|
              response.handle(resp, :if => response.responses[resp])
            end
          end
        end
      end
      
      alias :handle_show :handle_generic
      alias :handle_new :handle_generic
      alias :handle_index :handle_generic
      
      def handle_create(model, options = {})
        respond_to do |format|
          handle_response_base self, format, options do |response|
            if model.save
              response.generate_custom_flash "#{model.class} was successfully created."
              response.handle(:html, response.redirect )
            else
              response.outcome = :fail
              response.generate_custom_flash
              response.handle(:html, response.render_action("new"))
            end
            response.handle(:xml, response.render_xml(model, :action => "create") )
            response.handle(:js, :if => response.responses[:js], :use_outcome => true)
          end
        end
      end

      def handle_update(model, options = {})
        respond_to do |format|
          handle_response_base self, format, options do |response|
            if model.update_attributes(response.model_params)
              response.generate_custom_flash "#{model.class} was successfully updated."
              response.handle(:html, response.redirect )
            else
              response.outcome = :fail
              response.generate_custom_flash
              response.handle(:html, response.render_action("edit"))
            end

            response.handle(:xml, response.render_xml(model, :action => "update") )
            response.handle(:js, :if => response.responses[:js], :use_outcome => true)
          end
        end
      end

      def handle_destroy(model, options = {})
        respond_to do |format|
          handle_response_base self, format, options do |response|
            response.generate_custom_flash "#{model.class} was successfully deleted."
            response.handle(:html, response.redirect )
            response.handle(:xml, response.render_xml(model, :action => "destroy") )
            response.handle(:js, :if => response.responses[:js])
          end
        end
      end

      def handle_response_base(controller, responds_to, options = {}, &block)
        handler = ResponseHandler.new(controller, responds_to, options)
        block.call(handler)
      end

      class ResponseHandler
        attr_accessor :controller, :url, :model_params, :responses, :custom_flash, :action, :responds_to, :outcome

        def initialize(controller, responds_to, options = {})
          @controller =   controller
          @responds_to =  responds_to
          @url =          options[:url]
          @model_params = options[:params]
          @responses =    options[:response_for_type] || {}
          @custom_flash = options[:flash] || {}
          @action =       options[:action]
          @outcome =      options[:outcome] || :success
        end

        def handle(content_type, *args)
          options =         args.extract_options!
          default_action =  args.first || nil
          options[:use_outcome] ||= false
          response =        ((options[:use_outcome]) && self.responses[content_type]) ? self.responses[content_type][self.outcome] : self.responses[content_type]

          self.responds_to.send "#{content_type}" do
            self.restful_response(response, default_action) if !options[:if].nil? ? options[:if] : true
          end
        end

        def restful_response(block_or_nil, default_action = nil)
          default_action ||= lambda {|p| nil }
          (block_or_nil || default_action).call
        end

        def generate_custom_flash(default = nil)
          _flash = self.controller.send(:flash)
          return unless default || !self.custom_flash.empty?

          unless self.custom_flash.empty?
            self.custom_flash.keys.each do |key|
              _flash[key] = self.custom_flash[key][self.outcome] || default
            end
          else
            _flash[:notice] = default
          end
        end

        def redirect
          lambda { redirect_to(self.url.respond_to?(:call) ? self.url.call : self.url) }
        end

        def render_action(override = nil)
          lambda { render :action => (override || self.action) }
        end

        def render_xml(model, options = {})
          success = self.outcome == :success

          case options[:action]
          when "create"
            render_options = {}
            if success
              render_options.merge(:status => :created, :location => (options[:location] || model))
            else
              render_options.merge(:status => :unprocessable_entity)
            end
            lambda { render(render_options.merge(:xml => (success ? model : model.errors))) }
          when "update"
            if success
              lambda { head :ok }
            else
              lambda { render :xml => model.errors, :status => :unprocessable_entity }
            end
          when "destroy"
            lambda { head :ok }
          else
            lambda { render :xml => model }
          end
        end

        def method_missing(call, *args)
          super unless self.controller.send call, *args
        end
      end
    end
  end
end