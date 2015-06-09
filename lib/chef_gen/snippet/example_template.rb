module ChefGen
  module Snippet
    # a sample template source
    module ExampleTemplate
      # declares directories
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_exampletemplate_dirs(recipe)
        @directories << 'templates'
        @directories << File.join('templates', 'default')
      end

      # declares files
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_exampletemplate_files(recipe)
        @files_if_missing << File.join(
          'templates', 'default', 'example.conf.erb'
        )
      end

      # copies snippet content
      # @param path [String] the path to the temporary generator cookbook
      # @return [void]
      def content_exampletemplate_files(path)
        %w(templates_default_example_conf_erb).each do |file|
          copy_snippet_file(
            File.join(
              File.dirname(__FILE__), '..', '..', '..',
              'shared', 'snippet', 'exampletemplate', file
            ),
            File.join(path, 'files', 'default', file)
          )
        end
      end
    end
  end
end
