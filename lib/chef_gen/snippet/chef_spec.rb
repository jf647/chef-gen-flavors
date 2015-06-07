module ChefGen
  module Snippet
    # creates a framework for ChefSpec unit testing
    module ChefSpec
      # declares directories
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_chefspec_dirs(recipe)
        @directories << 'spec'
        @directories << File.join('spec', 'recipes')
      end

      # declares files
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_chefspec_files(recipe)
        @templates << '.rspec'
        @templates_if_missing << File.join('spec', 'spec_helper.rb')
        @templates_if_missing << File.join('spec', 'recipes', 'default_spec.rb')
        @templates_if_missing << File.join('spec', 'chef_runner_context.rb')
      end

      # adds chefspec files to the git and chefignore patterns
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_chefspec_ignore(recipe)
        return unless respond_to?(:chefignore_patterns)
        %w(
          .rspec
          spec/*
          spec/fixtures/*
        ).each do |e|
          chefignore_patterns << e
        end
      end

      # adds chefspec gems to the Gemfile
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_chefspec_gems(recipe)
        return unless respond_to?(:cookbook_gems)
        cookbook_gems['chefspec'] = '~> 4.1'
        cookbook_gems['guard-rspec'] = '~> 4.5'
        cookbook_gems['ci_reporter_rspec'] = '~> 1.0'
      end

      # adds chefspec rake tasks to the Rakefile
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_chefspec_raketasks(recipe)
        return unless respond_to?(:rake_tasks)
        rake_tasks['chefspec'] = <<'END'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:chefspec)

desc 'Generate ChefSpec coverage report'
task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task[:chefspec].invoke
end
task spec: :chefspec
END
      end

      # adds chefspec sets to the Guardfile
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_chefspec_guardsets(recipe)
        return unless respond_to?(:guard_sets)
        guard_sets['chefspec'] = <<'END'
rspec_command = ENV.key?('DISABLE_PRY_RESCUE') ? 'rspec' : 'rescue rspec'
guard :rspec, all_on_start: true, cmd: "bundle exec #{rspec_command}" do
  watch(%r{^spec/recipes/.+_spec\.rb$})
  watch(%r{^spec/spec_helper\.rb$}) { 'spec' }
  watch(%r{^attributes/.+\.rb$})    { 'spec' }
  watch(%r{^resources/.+\.rb$})     { 'spec' }
  watch(%r{^providers/.+\.rb$})     { 'spec' }
  watch(%r{^libraries/.+\.rb$})     { 'spec' }
  watch(%r{^recipes/(.+)\.rb$})     { |m| "spec/recipes/#{m[1]}_spec.rb" }
end
END
      end

      # copies snippet content
      # @param path [String] the path to the temporary generator cookbook
      # @return [void]
      def content_chefspec_files(path)
        %w(
          _rspec.erb
          spec_spec_helper_rb.erb
          spec_recipes_default_spec_rb.erb
          spec_chef_runner_context_rb.erb
        ).each do |file|
          copy_snippet_file(
            File.join(
              File.dirname(__FILE__), '..', '..', '..',
              'shared', 'snippet', 'chef_spec', file
            ),
            File.join(path, 'templates', 'default', file)
          )
        end
      end
    end
  end
end
