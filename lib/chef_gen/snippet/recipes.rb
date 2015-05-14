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
    end
  end
end
