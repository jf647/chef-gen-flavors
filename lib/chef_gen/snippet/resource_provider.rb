module ChefGen
  module Snippet
    # a cookbook that has provides resources and providers
    module ResourceProvider
      # declares directories
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_resourceprovider_dirs(recipe)
        @directories << 'resources'
        @directories << 'providers'
      end

      # declares files
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_resourceprovider_files(recipe)
        @templates_if_missing << File.join('resources', 'default.rb')
        @templates_if_missing << File.join('providers', 'default.rb')
      end
    end
  end
end
