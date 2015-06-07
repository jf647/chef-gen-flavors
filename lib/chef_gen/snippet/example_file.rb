module ChefGen
  module Snippet
    # a sample cookbook_file source
    module ExampleFile
      # declares directories
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_examplefile_dirs(recipe)
        @directories << 'files'
        @directories << File.join('files', 'default')
      end

      # declares files
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_examplefile_files(recipe)
        @files_if_missing << File.join('files', 'default', 'example.conf')
      end

      # copies snippet content
      # @param path [String] the path to the temporary generator cookbook
      # @return [void]
      def content_examplefile_files(path)
        %w(files_default_example_conf).each do |file|
          copy_snippet_file(
            File.join(
              File.dirname(__FILE__), '..', '..', '..',
              'shared', 'snippet', 'examplefile', file
            ),
            File.join(path, 'files', 'default', file)
          )
        end
      end
    end
  end
end
