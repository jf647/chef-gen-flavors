# rubocop:disable Metrics/MethodLength

require 'chef/mixin/params_validate'

module ChefGen
  module Snippet
    # creates the basic files that every cookbook should have
    # each file is managed through a separate method to allow for
    # people to mix this in but turn off just one file
    module CookbookBase
      # adds a Hash for gems to add to the gemfile
      attr_reader :cookbook_gems

      # adds an Array of gem sources, defaulting to rubygems
      attr_reader :gem_sources

      # adds an Array of berks sources, defaulting to supermarket
      attr_reader :berks_sources

      # adds a Hash of rake tasks
      attr_reader :rake_tasks

      # adds a Hash of guard sets
      attr_reader :guard_sets

      # initializes instance vars
      def init_cookbookbase_instancevars
        @gem_sources = %w(https://rubygems.org)
        @berks_sources = %w(https://supermarket.chef.io)
        @rake_tasks = {}
        @guard_sets = {}
        @cookbook_gems = {
          'rake' => '~> 10.4',
          'pry' => '~> 0.10',
          'pry-byebug' => '~> 3.1',
          'pry-rescue' => '~> 1.4',
          'pry-stack_explorer' => '~> 0.4',
          'berkshelf' => '~> 3.3',
          'guard' => '~> 2.12'
        }
      end

      # declares files
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_cookbookbase_files(recipe)
        @templates_if_missing << 'metadata.rb'
        @templates_if_missing << 'README.md'
        @templates_if_missing << 'CHANGELOG.md'
      end

      # declares the Gemfile with lazy evaluation of the gems
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_cookbookbase_gemfile(recipe)
        gems = @cookbook_gems
        sources = @gem_sources
        lazy_vars = Chef::DelayedEvaluator.new do
          { gems: gems, sources: sources }
        end
        # :nocov:
        add_render(
          %w(Gemfile),
          resource_action: :create,
          attrs: { variables: lazy_vars }
        )
        # :nocov:
      end

      # declares the Berksfile with lazy evaluation of the sources
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_cookbookbase_berksfile(recipe)
        sources = @berks_sources
        lazy_vars = Chef::DelayedEvaluator.new do
          { sources: sources }
        end
        # :nocov:
        add_render(
          %w(Berksfile),
          resource_action: :create,
          attrs: { variables: lazy_vars }
        )
        # :nocov:
      end

      # declares the Rakefile with lazy evaluation of the tasks
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_cookbookbase_rakefile(recipe)
        tasks = @rake_tasks
        lazy_vars = Chef::DelayedEvaluator.new do
          { tasks: tasks }
        end
        # :nocov:
        add_render(
          %w(Rakefile),
          resource_action: :create,
          attrs: { variables: lazy_vars }
        )
        # :nocov:
      end

      # declares the Guardfile with lazy evaluation of the guards
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_cookbookbase_guardfile(recipe)
        guards = @guard_sets
        lazy_vars = Chef::DelayedEvaluator.new do
          { guards: guards }
        end
        # :nocov:
        add_render(
          %w(Guardfile),
          resource_action: :create,
          attrs: { variables: lazy_vars }
        )
        # :nocov:
      end

      # adds base files to the git and chefignore patterns
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_cookbookbase_ignore(recipe)
        return unless respond_to?(:chefignore_patterns)
        %w(
          Gemfile Rakefile Guardfile Berksfile
        ).each do |e|
          chefignore_patterns << e
        end
      end

      # copies snippet content
      # @param path [String] the path to the temporary generator cookbook
      # @return [void]
      def content_cookbookbase_files(path)
        %w(
          Gemfile.erb Berksfile.erb Rakefile.erb Guardfile.erb
          metadata_rb.erb README_md.erb CHANGELOG_md.erb
        ).each do |file|
          # :nocov:
          copy_snippet_file(
            File.join(
              File.dirname(__FILE__), '..', '..', '..',
              'shared', 'snippet', 'cookbookbase', file
            ),
            File.join(path, 'templates', 'default', file)
          )
          # :nocov:
        end
      end
    end
  end
end
