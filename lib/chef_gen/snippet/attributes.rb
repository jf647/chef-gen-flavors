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
    end
  end
end
