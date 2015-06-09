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

      # copies snippet content
      # @param path [String] the path to the temporary generator cookbook
      # @return [void]
      def content_resourceprovider_files(path)
        %w(
          resources_default_rb.erb
          providers_default_rb.erb
        ).each do |file|
          copy_snippet_file(
            File.join(
              File.dirname(__FILE__), '..', '..', '..',
              'shared', 'snippet', 'resourceprovider', file
            ),
            File.join(path, 'templates', 'default', file)
          )
        end
      end
    end
  end
end
