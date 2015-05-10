module ChefDK
  module Template
    module Mixin
      # a sample cookbook_file source
      module ExampleFile
        # declares directories
        # @param recipe [Chef::Recipe] the recipe into which resources
        #   will be injected
        # @return [void]
        def mixin_examplefile_dirs(recipe)
          @directories << 'files'
          @directories << File.join('files', 'default')
        end

        # declares files
        # @param recipe [Chef::Recipe] the recipe into which resources
        #   will be injected
        # @return [void]
        def mixin_examplefile_files(recipe)
          @files_if_missing << File.join('files', 'default', 'example.conf')
        end
      end
    end
  end
end
