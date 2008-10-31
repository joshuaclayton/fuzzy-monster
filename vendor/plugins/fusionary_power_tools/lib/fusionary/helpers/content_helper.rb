module Fusionary
  module Helpers
    module ContentHelper
      def content(*args, &block)
        args.insert(0, :three_fourths) if args.empty?
        content_builder(:content, *(args + [{:id => "content"}]), &block)
      end

      def extra_content(*args, &block)
        args.insert(0, :one_fourth) if args.empty?
        content_builder(:extra_content, *(args + [:last, {:id => "extra-content"}]), &block)
      end

      def inline_form(&block)
        content_builder(:inline_form, :eleven_twelfths, prepend_one_twentyfourth(), :last, :id => 'inline-form', &block)
      end
      
      def sub_header(&block)
        subhead = content_for(:sub_header, capture(&block))
        concat(yield(:sub_header))
      end
      
      alias :subheader :sub_header
      
      private

      def content_builder(area, *args, &block)
        options = args.extract_options!
        size = args.shift || :full

        section = content_for area do 
          column size, *[args, options].flatten do
            capture(&block)
          end
        end

        concat(yield(area))
      end
    end
  end
end