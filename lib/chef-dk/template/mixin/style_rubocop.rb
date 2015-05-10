module ChefDK
  module Template
    module Mixin
      # sets up style testing using Rubocop
      module StyleRubocop
        # declares the rubocop config file
        # @param recipe [Chef::Recipe] the recipe into which resources
        #   will be injected
        # @return [void]
        def mixin_stylerubocop_config(recipe)
          @templates_if_missing << '.rubocop.yml'
        end
      end
    end
  end
end
