require 'chef-dk/generator'

module ChefGen
  # a base for ChefDK Template Flavors
  class FlavorBase
    # the target path of 'chef generate'
    # @return [String] path
    attr_reader :target_path

    # directories to create
    # @return [Array] list of directories
    attr_reader :directories

    # files to create unconditionally
    # @return [Array] list of destination filenames
    attr_reader :files

    # files to create only if they do not exist
    # @return [Array] list of destination filenames
    attr_reader :files_if_missing

    # templates to render unconditionally
    # @return [Array] list of destination filenames
    attr_reader :templates

    # templates to render only if they do not exist
    # @return [Array] list of destination filenames
    attr_reader :templates_if_missing

    # an informational block about how the user should proceed
    # @return [String] instructions
    attr_accessor :next_steps

    # whether to fail if files would be overwritten
    # @return [Boolean] true to fail on attempted overwrite
    attr_accessor :fail_on_clobber

    # whether to report the actions that were taken
    # @return [Boolean] true to report actions
    attr_accessor :report_actions

    # creates a new flavor object
    # @param recipe [Chef::Recipe] the recipe into which
    #   resources will be injected
    # @return [self]
    def initialize(recipe)
      # store the recipe we'll be injecting resources into
      @recipe = recipe

      # derive our target path
      ctx = generator_context
      @target_path = File.expand_path(
        File.join(ctx.cookbook_root, ctx.cookbook_name)
      )

      # set defaults
      @report_actions = true
      @fail_on_clobber = !ctx.respond_to?(:clobber)
      @directories = []
      %w(directories files files_if_missing templates
         templates_if_missing actions_taken failures).each do |varname|
        instance_variable_set("@#{varname}".to_sym, [])
      end

      # call initializers defined by snippets
      methods_by_pattern(/^init_/).each do |m|
        send(m)
      end
    end

    # find all public methods of the flavor starting with content_
    # and calls them, passing the path as the sole parameter
    # @param path [String] the path to the copy of the generator cookbook
    # @return [void]
    def add_content(path)
      methods_by_pattern(/^content_/).each do |m|
        send(m, path)
      end
    end

    # copy a snippet content file to the temporary generator path,
    # creating the destination directory if it does not already exist
    # @param src [String] the source file
    # @param dst [String] the destination file
    # @return [void]
    def copy_snippet_file(src, dst)
      # make sure the parent of the destination exists
      parent = File.dirname(dst)
      FileUtils.mkpath(parent) unless Dir.exist?(parent)
      # copy the file
      FileUtils.copy_file(src, dst)
    end

    # a proxy to ChefDK's generator context
    # @return [ChefDK::Generator::Context]
    def generator_context
      ChefDK::Generator.context
    end

    # generates the Chef resources that the plugin has declared
    # @return [void]
    def generate
      add_target_path
      run_snippets
      after_run_snippets if respond_to?(:after_run_snippets)
      add_directories
      add_files
      add_templates
      unless @failures.empty?
        @failures.each { |f| $stderr.puts f }
        fail 'errors during generation'
      end
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

    # creates a directory resource for the target
    # @return [void]
    def add_target_path
      @recipe.send(:directory, @target_path)
      @actions_taken << "create directory #{@target_path}"
    end

    # find all public methods of the flavor starting with snippet_
    # and calls them
    # @return [void]
    # @yield [Chef::Recipe] the recipe into which the mixin can inject
    #   resources
    # @api private
    def run_snippets
      methods_by_pattern(/^snippet_/).each do |m|
        send(m, @recipe)
      end
    end

    # returns a list of public methods that match a pattern
    # @param pattern [Regexp] the pattern to match methods against
    # @return [Array] a list of sorted methods
    def methods_by_pattern(pattern)
      public_methods.select do |m|
        m.to_s =~ pattern
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

    # declares a cookbook_file resource for each element of '#files' and
    # '#files_if_missing', respecting the value of '#fail_on_clobber'
    # @return [void]
    # @api private
    def add_files
      add_render(
        @files,
        suffix: '', resource: :cookbook_file, resource_action: :create
      )
      add_render(
        @files_if_missing,
        suffix: '', clobberfail: false, resource: :cookbook_file
      )
    end

    # declares a template resource for each element of '#templates' and
    # '#templates_if_missing', respecting the value of '#fail_on_clobber'
    # @return [void]
    # @api private
    def add_templates
      add_render(@templates, resource_action: :create)
      add_render(@templates_if_missing, clobberfail: false)
    end

    # does the heavy lifting for add_files and add_templates
    # @param things [Array] the list of things to declare
    # @param suffix [String] a suffix to add to the source file
    # @param clobberfail [Boolean] whether to protect against
    #   overwriting files
    # @param resource [Symbol] the symbolized Chef resource to declare
    # @param resource_action [Symbol] the action to give the resource
    # @param attrs [Hash] additional attributes to send to the resource.
    #   Keys are methods, values are parameters
    # @return [void]
    # @api private
    def add_render( # rubocop:disable Metrics/ParameterLists
      things,
      suffix: '.erb', clobberfail: @fail_on_clobber,
      resource: :template, resource_action: :create_if_missing,
      attrs: {}
    )
      things.flatten.each do |filename|
        src = "#{source_path(filename)}#{suffix}"
        dst = File.join(@target_path, filename)
        if clobberfail && File.exist?(dst)
          @failures << "tried to overwrite file #{dst}"
        else
          _add_resource(resource, src, dst, resource_action, attrs)
        end
      end
    end

    # adds a resource to the recipe
    # @api private
    def _add_resource(type, src, dst, action, attrs)
      @recipe.send(type, dst) do
        # :nocov:
        source src
        action action
        helpers(ChefDK::Generator::TemplateHelper) \
          if :template == resource
        attrs.each { |m, p| send m, p }
        # :nocov:
      end
      @actions_taken << "add resource #{type}[#{dst}]"
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
