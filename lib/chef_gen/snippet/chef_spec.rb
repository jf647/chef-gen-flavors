module ChefGen
  module Snippet
    # creates a framework for ChefSpec unit testing
    module ChefSpec
      # declares the .rspec file
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_chefspec_dotrspec(recipe)
        @templates << '.rspec'
      end

      # declares the ChefSpec directories
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_chefspec_dirs(recipe)
        @directories << 'spec'
        @directories << File.join('spec', 'recipes')
      end

      # declares the ChefSpec spec_helper
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_chefspec_spechelper(recipe)
        @templates_if_missing << File.join('spec', 'spec_helper.rb')
      end

      # declares the default recipe spec
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_chefspec_defaultrecipespec(recipe)
        @templates_if_missing << File.join(
          'spec', 'recipes', 'default_spec.rb'
        )
      end
    end
  end
end
