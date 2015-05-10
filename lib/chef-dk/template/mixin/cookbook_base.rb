module ChefDK
  module Template
    module Mixin
      # creates the basic files that every cookbook should have
      # each file is managed through a separate method to allow for
      # people to mix this in but turn off just one file
      module CookbookBase
        # declares the Gemfile
        # @param recipe [Chef::Recipe] the recipe into which resources
        #   will be injected
        # @return [void]
        def mixin_cookbookbase_gemfile(recipe)
          @templates << 'Gemfile'
        end

        # declares the Berksfile
        # @param recipe [Chef::Recipe] the recipe into which resources
        #   will be injected
        # @return [void]
        def mixin_cookbookbase_berksfile(recipe)
          @templates << 'Berksfile'
        end

        # declares the Rakefile
        # @param recipe [Chef::Recipe] the recipe into which resources
        #   will be injected
        # @return [void]
        def mixin_cookbookbase_rakefile(recipe)
          @templates << 'Rakefile'
        end

        # declares the Guardfile
        # @param recipe [Chef::Recipe] the recipe into which resources
        #   will be injected
        # @return [void]
        def mixin_cookbookbase_guardfile(recipe)
          @templates << 'Guardfile'
        end

        # declares the metadata.rb file
        # @param recipe [Chef::Recipe] the recipe into which resources
        #   will be injected
        # @return [void]
        def mixin_cookbookbase_metadata(recipe)
          @templates_if_missing << 'metadata.rb'
        end

        # declares the README file
        # @param recipe [Chef::Recipe] the recipe into which resources
        #   will be injected
        # @return [void]
        def mixin_cookbookbase_readme(recipe)
          @templates_if_missing << 'README.md'
        end

        # declares the CHANGELOG
        # @param recipe [Chef::Recipe] the recipe into which resources
        #   will be injected
        # @return [void]
        def mixin_cookbookbase_changelog(recipe)
          @templates_if_missing << 'CHANGELOG.md'
        end
      end
    end
  end
end
