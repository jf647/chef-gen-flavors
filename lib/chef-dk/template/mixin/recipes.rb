module ChefDK
  module Template
    module Mixin
      # a cookbook that has recipes
      module Recipes
        # declares directories
        # @param recipe [Chef::Recipe] the recipe into which resources
        #   will be injected
        # @return [void]
        def mixin_recipes_dirs(recipe)
          @directories << 'recipes'
        end

        # declares files
        # @param recipe [Chef::Recipe] the recipe into which resources
        #   will be injected
        # @return [void]
        def mixin_recipes_files(recipe)
          @templates_if_missing << File.join('recipes', 'default.rb')
        end
      end
    end
  end
end
