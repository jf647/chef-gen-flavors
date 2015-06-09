module ChefGen
  module Snippet
    # a cookbook that has recipes
    module Recipes
      # declares directories
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_recipes_dirs(recipe)
        @directories << 'recipes'
      end

      # declares files
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_recipes_files(recipe)
        @templates_if_missing << File.join('recipes', 'default.rb')
      end

      # copies snippet content
      # @param path [String] the path to the temporary generator cookbook
      # @return [void]
      def content_recipes_files(path)
        %w(recipes_default_rb.erb).each do |file|
          copy_snippet_file(
            File.join(
              File.dirname(__FILE__), '..', '..', '..',
              'shared', 'snippet', 'recipes', file
            ),
            File.join(path, 'templates', 'default', file)
          )
        end
      end
    end
  end
end
