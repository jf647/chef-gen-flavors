# rubocop:disable Metrics/MethodLength
module ChefGen
  module Snippet
    # creates a framework for Test Kitchen integration testing
    module TestKitchen
      # declares directories
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_testkitchen_dirs(recipe)
        @directories << 'test'
        @directories << File.join('test', 'integration')
        @directories << File.join('test', 'integration', 'default')
        @directories << File.join(
          'test', 'integration', 'default', 'serverspec'
        )
        @directories << File.join(
          'test', 'integration', 'default', 'serverspec', 'recipes'
        )
      end

      # declares the Test Kitchen config
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_testkitchen_files(recipe)
        @templates_if_missing << '.kitchen.yml'
        @templates_if_missing << File.join(
          'test', 'integration', 'default', 'serverspec', 'spec_helper.rb'
        )
        @templates_if_missing << File.join(
          'test', 'integration', 'default', 'serverspec',
          'recipes', 'default_spec.rb'
        )
      end

      # adds testkitchen to the git and chefignore patterns
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_testkitchen_ignore(recipe)
        %w(
          .vagrant
          .kitchen/
          .kitchen.local.yml
        ).each do |e|
          gitignore_patterns << e if respond_to?(:gitignore_patterns)
          chefignore_patterns << e if respond_to?(:chefignore_patterns)
        end
      end

      # adds testkitchen gems to the Gemfile
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_testkitchen_gems(recipe)
        return unless respond_to?(:cookbook_gems)
        cookbook_gems['test-kitchen'] = '~> 1.4'
        cookbook_gems['kitchen-vagrant'] = '~> 0.16'
      end

      # adds testkitchen rake tasks to the Rakefile
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_testkitchen_raketasks(recipe)
        return unless respond_to?(:rake_tasks)
        rake_tasks['testkitchen'] = <<'END'
begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue
  puts 'test-kitchen initialization failed; disabling kitchen tasks'
end
task integration: 'kitchen:all'
END
      end

      # copies snippet content
      # @param path [String] the path to the temporary generator cookbook
      # @return [void]
      def content_testkitchen_files(path)
        %w(
          _kitchen_yml.erb
          test_integration_default_serverspec_spec_helper_rb.erb
          test_integration_default_serverspec_recipes_default_spec_rb.erb
        ).each do |file|
          copy_snippet_file(
            File.join(
              File.dirname(__FILE__), '..', '..', '..',
              'shared', 'snippet', 'testkitchen', file
            ),
            File.join(path, 'templates', 'default', file)
          )
        end
        copy_snippet_file(
          File.join(
            File.dirname(__FILE__), '..', '..', '..',
            'shared', 'snippet', 'testkitchen', 'libraries_kitchen_helper_rb'
          ),
          File.join(path, 'libraries', 'kitchen_helper.rb')
        )
      end
    end
  end
end
