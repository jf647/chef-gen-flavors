module ChefGen
  module Snippet
    # sets up style testing using Rubocop
    module StyleRubocop
      # declares the rubocop config file
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_stylerubocop_config(recipe)
        @templates_if_missing << '.rubocop.yml'
      end

      # adds rubocop gems to the Gemfile
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_stylerubocop_gems(recipe)
        return unless respond_to?(:cookbook_gems)
        cookbook_gems['rubocop'] = '~> 0.31'
        cookbook_gems['guard-rubocop'] = '~> 1.1'
      end

      # copies snippet content
      # @param path [String] the path to the temporary generator cookbook
      # @return [void]
      def content_stylerubocop_files(path)
        %w(_rubocop_yml.erb).each do |file|
          copy_snippet_file(
            File.join(
              File.dirname(__FILE__), '..', '..', '..',
              'shared', 'snippet', 'stylerubocop', file
            ),
            File.join(path, 'templates', 'default', file)
          )
        end
      end

      # rubocop:disable Metrics/MethodLength

      # adds rubocop rake tasks to the Rakefile
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_rubocop_raketasks(recipe)
        return unless respond_to?(:rake_tasks)
        rake_tasks['rubocop'] = <<'END'
require 'rubocop/rake_task'

RuboCop::RakeTask.new(:rubocop) do |t|
  t.formatters = ['progress']
  t.options = ['-D']
  t.patterns = %w(
    attributes/*.rb
    recipes/*.rb
    libraries/**/*.rb
    resources/*.rb
    providers/*.rb
    spec/**/*.rb
    test/**/*.rb
    ./metadata.rb
    ./Berksfile
    ./Gemfile
    ./Rakefile
  )
end
task style: :rubocop
END
      end

      # adds rubocop sets to the Guardfile
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_rubocop_guardsets(recipe)
        return unless respond_to?(:guard_sets)
        guard_sets['rubocop'] = <<'END'
guard :rubocop, all_on_start: true, cli: ['-f', 'p', '-D'] do
  watch(%r{^attributes/.+\.rb$})
  watch(%r{^recipes/.+\.rb$})
  watch(%r{^libraries/.+\.rb$})
  watch(%r{^resources/.+\.rb$})
  watch(%r{^providers/.+\.rb$})
  watch(%r{^spec/.+\.rb$})
  watch(%r{^test/.+\.rb$})
  watch(%r{^metadata\.rb$})
  watch(%r{^Berksfile$})
  watch(%r{^Gemfile$})
  watch(%r{^Rakefile$})
end
END
      end
    end
  end
end
