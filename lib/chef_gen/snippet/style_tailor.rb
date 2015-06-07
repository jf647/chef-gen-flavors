module ChefGen
  module Snippet
    # sets up style testing using Tailor
    module StyleTailor
      # adds tailor gems to the Gemfile
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_styletailor_gems(recipe)
        return unless respond_to?(:cookbook_gems)
        cookbook_gems['tailor'] = '~> 1.4'
        cookbook_gems['guard-rake'] = '~> 0.0'
      end

      # rubocop:disable Metrics/MethodLength

      # adds tailor rake tasks to the Rakefile
      # @param recipe [Chef::Recipe] the recipe into which resources
      #   will be injected
      # @return [void]
      def snippet_tailor_raketasks(recipe)
        return unless respond_to?(:rake_tasks)
        rake_tasks['tailor'] = <<'END'
require 'tailor/rake_task'
Tailor::RakeTask.new do |t|
  {
    spec:        'spec/recipes/*_spec.rb',
    spec_helper: 'spec/spec_helper.rb',
    attributes:  'attributes/*.rb',
    resources:   'resources/*.rb',
    providers:   'providers/*.rb',
    libraries:   'libraries/**/*.rb',
    recipes:     'recipes/*.rb',
    metadata:    'metadata.rb'
  }.each do |name, glob|
    t.file_set glob, name do |s|
      s.max_line_length 1000
      s.max_code_lines_in_method 1000
      s.max_code_lines_in_class 1000
    end
  end
end
task style: :tailor
END
      end
    end
  end
end
