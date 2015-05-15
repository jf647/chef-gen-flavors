module ChefGen
  module Snippet
    # initializes a git repo
    module GitInit
      # executes 'git init .'
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_gitinit(recipe)
        c = generator_context
        recipe.send(:execute, 'initialize git repo') do
          command('git init .')
          cwd @target_path
        end if c.have_git && !c.skip_git_init
      end
    end
  end
end
