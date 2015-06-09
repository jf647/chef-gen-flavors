module ChefGen
  module Snippet
    # a cookbook that has attributes
    module Attributes
      # declares directories
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_attributes_dirs(recipe)
        @directories << 'attributes'
      end

      # declares files
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_attributes_files(recipe)
        @templates_if_missing << File.join('attributes', 'default.rb')
      end

      # copies snippet content
      # @param path [String] the path to the temporary generator cookbook
      # @return [void]
      def content_attribute_files(path)
        copy_snippet_file(
          File.join(
            File.dirname(__FILE__), '..', '..', '..',
            'shared', 'snippet', 'attributes', 'attributes_default_rb.erb'
          ),
          File.join(path, 'templates', 'default', 'attributes_default_rb.erb')
        )
      end
    end
  end
end
