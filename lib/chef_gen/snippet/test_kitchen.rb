module ChefGen
  module Snippet
    # creates a framework for Test Kitchen integration testing
    module TestKitchen
      # declares the Test Kitchen config
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_testkitchen_config(recipe)
        @templates_if_missing << '.kitchen.yml'
      end

      # declares directories
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_testkitchen_dirs(recipe)
        @directories << 'test'
        @directories << File.join('test', 'integration')
        @directories << File.join('test', 'integration', 'default')
        @directories << File.join(
          'test', 'integration', 'default', 'serverspec'
        )
        @directories << File.join(
          'test', 'integration', 'default', 'serverspec', 'recipes'
        )
      end

      # declares the Test Kitchen spec helper
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_testkitchen_spechelper(recipe)
        @templates_if_missing << File.join(
          'test', 'integration', 'default', 'serverspec', 'spec_helper.rb'
        )
      end

      # declares the Test Kitchen default recipe spec
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_testkitchen_defaultrecipespec(recipe)
        @templates_if_missing << File.join(
          'test', 'integration', 'default', 'serverspec',
          'recipes', 'default_spec.rb'
        )
      end
    end
  end
end
