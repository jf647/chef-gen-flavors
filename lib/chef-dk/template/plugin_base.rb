require 'chef-dk/generator'

module ChefDK
  module Template
    # a base for ChefDK Template plugins
    class PluginBase
      # @!attribute [r] target_path
      #   @return [String] the target path of 'chef generate'
      # @!attribute [r] directories
      #   @return [Array] the directories to create
      # @!attribute [r] files
      #   @return [Array] the files to create unconditionally
      # @!attribute [r] files_if_missing
      #   @return [Array] the files to create only if they do not exist
      # @!attribute [r] templates
      #   @return [Array] the templates to render unconditionally
      # @!attribute [r] templates_if_missing
      #   @return [Array] the templates to render only if they do not exist
      # @!attribute [r] chefignore_files
      #   @return [Array] file patterns to add to chefignore
      # @!attribute [r] gitignore_files
      #   @return [Array] file patterns to add to .gitignore
      attr_reader :target_path,
                  :directories,
                  :chefignore_files,
                  :gitignore_files,
                  :files, :files_if_missing,
                  :templates, :templates_if_missing

      # @!attribute next_steps
      #   @return [String] an informational block about how the user should
      #     proceed
      # @!attribute fail_on_clobber
      #   @return [Boolean] whether to fail if files would be overwritten
      # @!attribute report_actions
      #   @return [Boolean] whether to report the actions that were taken
      attr_accessor :fail_on_clobber, :report_actions, :next_steps

      # creates a new plugin object
      # @param recipe [Chef::Recipe] the recipe into which
      #   resources will be injected
      # @return [self]
      def initialize(recipe)
        # store the recipe we'll be injecting resources into
        @recipe = recipe

        # derive our target path
        ctx = ChefDK::Generator.context
        @target_path = File.expand_path(
          File.join(ctx.cookbook_root, ctx.cookbook_name)
        )

        # set defaults
        @report_actions = true
        @fail_on_clobber = !ctx.respond_to?(:clobber)
        @directories = [''] # root directory
        %w(files files_if_missing templates templates_if_missing
           chefignore_files gitignore_files actions_taken failures)
          .each do |varname|
          instance_variable_set("@#{varname}".to_sym, [])
        end
      end

      # generates the Chef resources that the plugin has declared
      # @return [void]
      def generate
        run_mixins
        add_directories
        add_files
        add_templates
        unless @failures.empty?
          @failures.each { |f| $stderr.puts f }
          fail 'errors during generation'
        end
        build_ignore('.gitignore', @gitignore_files)
        build_ignore('chefignore', @chefignore_files)
        report_actions_taken(@actions_taken) \
          if @report_actions && @actions_taken
        display_next_steps(@next_steps) if @next_steps
      end

      # given a destination file, returns a flattened source
      # filename by replacing / and . with _
      # @param path [String] the destination file
      # @return [String] the flattened source file
      # @example convert a destination file
      #   source_path('spec/spec_helper.rb') #=> 'spec_spec_helper_rb'
      def source_path(path)
        path.tr('/.', '_')
      end

      private

      # find all public methods of the plugin starting with mixin_
      # and calls them
      # @return [void]
      # @yield [Chef::Recipe] the recipe into which the mixin can inject
      #   resources
      # @api private
      def run_mixins
        mixin_methods = public_methods.select do |m|
          m.to_s =~ /^mixin_/
        end
        mixin_methods.each do |m|
          send(m, @recipe)
        end
      end

      # declares a directory resource for each element of @directories
      # @return [void]
      # @api private
      def add_directories
        @directories.flatten.each do |dirname|
          path = File.join(@target_path, dirname)
          @recipe.send(:directory, path)
          @actions_taken << "create directory #{path}"
        end
      end

      # declares a cookbook_file resource for each element of #files and
      # #files_if_missing, respecting the value of #fail_on_clobber
      # @return [void]
      # @api private
      def add_files
        _add_files(
          @files, nil, @fail_on_clobber, :cookbook_file, :create
        )
        _add_files(
          @files_if_missing, nil, false, :cookbook_file, :create_if_missing
        )
      end

      # declares a template resource for each element of #files and
      # #files_if_missing, respecting the value of #fail_on_clobber
      # @return [void]
      # @api private
      def add_templates
        _add_files(
          @templates, '.erb', @fail_on_clobber, :template, :create
        )
        _add_files(
          @templates_if_missing, '.erb', false, :template, :create_if_missing
        )
      end

      # does the heavy lifting for add_files and add_templates
      # @param files [Array] the list of things to declare
      # @param suffix [String] a suffix to add to the source file
      # @param clobberfail [Boolean] whether to protect against
      #   overwriting files
      # @param resource [Symbol] the symbolized Chef resource to declare
      # @param resource_action [Symbol] the action to give the resource
      # @return [void]
      # @api private
      def _add_files(files, suffix, clobberfail, resource, resource_action)
        files.flatten.each do |filename|
          src = "#{source_path(filename)}#{suffix}"
          dst = File.join(@target_path, filename)
          if clobberfail && File.exist?(dst)
            @failures << "tried to overwrite file #{dst}"
          else
            @recipe.send(resource, dst) do
              # :nocov:
              source src
              action resource_action
              helpers(ChefDK::Generator::TemplateHelper) \
                if :template == resource
              # :nocov:
            end
            @actions_taken << "create file #{dst}"
          end
        end
      end

      # creates a .gitignore or chefignore file
      # @param dstfile [String] the destination file
      # @param entries [Array] an array of lines to write to the file
      # @return [void]
      # @api private
      def build_ignore(dstfile, files)
        return if files.empty?
        dst = File.join(@target_path, dstfile)
        @recipe.send(:file, dst) do
          # :nocov:
          content files.flatten.join("\n")
          # :nocov:
        end
        @actions_taken << "create ignore file #{dst}"
      end

      # reports on the actions taken by the plugin
      # @param actions [Array] the list of actions taken
      # @return [void]
      # @api private
      def report_actions_taken(actions)
        @recipe.send(:ruby_block, 'report_actions_taken') do
          # :nocov:
          block do
            $stdout.puts "\n\nactions taken:"
            actions.each { |a| $stdout.puts "  #{a}" }
          end
          # :nocov:
        end
      end

      # displays the next steps for the user to take
      # @return [void]
      # @api private
      def display_next_steps(next_steps)
        @recipe.send(:ruby_block, 'display_next_steps') do
          # :nocov:
          block do
            $stdout.puts next_steps
          end
          # :nocov:
        end
      end
    end
  end
end
