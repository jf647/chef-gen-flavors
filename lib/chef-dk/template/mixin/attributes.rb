module ChefDK
  module Template
    module Mixin
      # a cookbook that has attributes
      module Attributes
        # declares directories
        # @param recipe [Chef::Recipe] the recipe into which resources
        #   will be injected
        # @return [void]
        def mixin_attributes_dirs(recipe)
          @directories << 'attributes'
        end

        # declares files
        # @param recipe [Chef::Recipe] the recipe into which resources
        #   will be injected
        # @return [void]
        def mixin_attributes_files(recipe)
          @templates_if_missing << File.join('attributes', 'default.rb')
        end
      end
    end
  end
end
