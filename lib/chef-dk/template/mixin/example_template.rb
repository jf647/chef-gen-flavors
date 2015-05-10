module ChefDK
  module Template
    module Mixin
      # a sample template source
      module ExampleTemplate
        # declares directories
        # @param recipe [Chef::Recipe] the recipe into which resources
        #   will be injected
        # @return [void]
        def mixin_exampletemplate_dirs(recipe)
          @directories << 'templates'
          @directories << File.join('templates', 'default')
        end

        # declares files
        # @param recipe [Chef::Recipe] the recipe into which resources
        #   will be injected
        # @return [void]
        def mixin_exampletemplate_files(recipe)
          @files_if_missing << File.join(
            'templates', 'default', 'example.conf.erb'
          )
        end
      end
    end
  end
end
