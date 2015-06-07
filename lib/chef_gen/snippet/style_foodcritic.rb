module ChefGen
  module Snippet
    # sets up style testing using Foodcritic
    module StyleFoodcritic
      # adds foodcritic gems to the Gemfile
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_stylefoodcritic_gems(recipe)
        return unless respond_to?(:cookbook_gems)
        cookbook_gems['foodcritic'] = '~> 4.0'
        cookbook_gems['guard-foodcritic'] = '~> 1.1'
      end

      # adds foodcritic rake tasks to the Rakefile
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_foodcritic_raketasks(recipe)
        return unless respond_to?(:rake_tasks)
        rake_tasks['foodcritic'] = <<'END'
require 'foodcritic'
require 'foodcritic/rake_task'

FoodCritic::Rake::LintTask.new(:foodcritic)
task style: :foodcritic
END
      end

      # adds foodcritic sets to the Guardfile
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_foodcritic_guardsets(recipe)
        return unless respond_to?(:guard_sets)
        guard_sets['foodcritic'] = <<'END'
guard :foodcritic,
      cookbook_paths: '.',
      cli: '-f any -X spec -X test -X features' do
  watch(%r{^attributes/.+\.rb$})
  watch(%r{^resources/.+\.rb$})
  watch(%r{^providers/.+\.rb$})
  watch(%r{^libraries/.+\.rb$})
  watch(%r{^recipes/.+\.rb$})
  watch(%r{^metadata\.rb$})
end
END
      end
    end
  end
end
