# rubocop:disable Metrics/MethodLength
module ChefGen
  module Snippet
    # populates the list of ignore patterns for chefignore and .gitignore
    module StandardIgnore
      # adds an array for chefignore patterns
      attr_reader :chefignore_patterns

      # adds an array for gitignore patterns
      attr_reader :gitignore_patterns

      # initializes the pattern arrays
      def init_standardignore_instancevars
        @chefignore_patterns = %w(
          .DS_Store Icon? nohup.out ehthumbs.db Thumbs.db
          .sasscache \#* .#* *~ *.sw[az] *.bak REVISION TAGS*
          tmtags *_flymake.* *_flymake *.tmproj .project .settings
          mkmf.log a.out *.o *.pyc *.so *.com *.class *.dll
          *.exe */rdoc/ .watchr  test/* features/* Procfile
          .git */.git .gitignore .gitmodules .gitconfig .gitattributes
          .svn */.bzr/* */.hg/*
        )
        @gitignore_patterns = %w(
          Berksfile.lock *~ *# .#* \#*# .*.sw[az] *.un~
          bin/* .bundle/*
        )
      end

      # rubocop:disable Metrics/AbcSize

      # declares ignore files
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_standardignore_files(recipe)
        add_chefignore_resource(recipe)
        add_gitignore_resource(recipe)
      end

      private

      # add the chefignore file resource, with content from the list
      # of patterns in the instance var set to reasonable defaults
      # and lazily evaluated
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def add_chefignore_resource(recipe)
        patterns = @chefignore_patterns
        # :nocov:
        recipe.send(:file, File.join(@target_path, 'chefignore')) do
          content lazy { patterns.sort.uniq.join("\n") + "\n" }
        end
        # :nocov:
      end

      # add the .gitignore file resource, with content from the list
      # of patterns in the instance var set to reasonable defaults
      # and lazily evaluated
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def add_gitignore_resource(recipe)
        patterns = @gitignore_patterns
        # :nocov:
        recipe.send(:file, File.join(@target_path, '.gitignore')) do
          content lazy { patterns.sort.uniq.join("\n") + "\n" }
        end
        # :nocov:
      end
    end
  end
end
