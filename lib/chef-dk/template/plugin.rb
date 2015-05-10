require 'little-plugger'

# the Chef development kit
module ChefDK
  # templates for the 'chef generate' command
  module Template
    # a plugin framework for creating ChefDK generator templates
    class Plugin
      # the version of the gem
      VERSION = '0.1.0'

      extend LittlePlugger path: 'chef-dk/template/plugin',
                           module: ChefDK::Template::Plugin

      class << self
        # return the path to to the code_generator cookbook for
        # the selected ChefDK Template Plugin
        # @return [String] the path to the code_generator cookbook
        def path
          # validate what LittlePlugger found
          validate_plugins
          # then take a copy so we can augment it
          @plugins = plugins.dup
          add_builtin_template
          selected = plugin_from_env ||
                     only_plugin ||
                     prompt_for_plugin ||
                     fail('no ChefDK Template plugins found!')
          path = generator_path(selected)
          $stdout.puts "using ChefDK template generator in #{path}"
          path
        end

        private

        # validates all plugins found by LittlePlugger
        # @raise RuntimeError if any plugin is invalid
        # @return [void]
        # @api private
        def validate_plugins
          plugins.each do |name, klass|
            fail "no description for plugin #{name}" \
              unless klass.respond_to?(:description)
          end
        end

        # checks if the plugin to use has been specified in the environment
        # variable CHEFDK_TEMPLATE
        # @return [Symbol,nil] the plugin if specified and found, nil otherwise
        # @api private
        def plugin_from_env
          if ENV.key?('CHEFDK_TEMPLATE')
            candidate = ENV['CHEFDK_TEMPLATE'].downcase.to_sym
            return candidate if plugins.key?(candidate)
          end
          nil
        end

        # if the environment variable CHEFDK_TEMPLATE_BUILTIN is defined, adds
        # the built-in template that comes with ChefDK to the list of available
        # plugins
        # @return [void]
        # @api private
        def add_builtin_template
          @plugins[:builtin] = true if ENV.key?('CHEFDK_TEMPLATE_BUILTIN')
        end

        # returns the sole installed plugin if only one is found
        # @return [Symbol,nil] the plugin if only one is installed,
        #   nil otherwise
        # @api private
        def only_plugin
          @plugins.keys.size == 1 ? @plugins.keys.first : nil
        end

        # :nocov:

        # prompts the user for a plugin to use if more than one is available
        # @return [Symbol] the selected plugin
        # @raise RuntimeError if an invalid plugin is chosen
        # @api private
        def prompt_for_plugin
          return nil unless @plugins.keys.size >= 1
          require 'bogo-ui'
          ui = Bogo::Ui.new(app_name: 'ChefDK Template Selector')
          valid = plugin_selection(ui)
          response = ui.ask_question('Enter selection').to_i
          return valid[response.to_i] if valid[response]
          ui.fatal 'Invalid plugin chosen'
          fail 'Invalid ChefDK Template plugin'
        end

        # builds a list of plugins and displays them with as
        # a number selection list
        # @param ui [Bogo::Ui] the ui object to use for display
        # @return [Hash] a hash of valid options
        # @api private
        def plugin_selection(ui)
          output = [ui.color('Available Templates', :bold)]
          idx = 1
          valid = {}
          @plugins.each do |name, klass|
            valid[idx] = name
            if true == klass
              output << "#{idx}. ChefDK built-in template"
            else
              output << "#{idx}. #{name}: #{klass.description}"
            end
            idx += 1
          end
          ui.info "#{output.join("\n")}\n"
          valid
        end
        # :nocov:

        # returns the path to the code_generator cookbook for the
        # selected plugin.  Handles the built-in template path,
        # a plugin that overrides the path and a plugin that uses
        # the default path
        # @param plugin [Symbol] the selected plugin
        # @return [String] the path to the code_generator cookbook
        # @api private
        def generator_path(plugin)
          return builtin_code_generator_path if :builtin == plugin
          klass = @plugins[plugin]
          classfile = path_to_plugin(klass)
          if klass.respond_to?(:code_generator_path)
            klass.code_generator_path(classfile)
          else
            default_code_generator_path(classfile)
          end
        end

        # returns the path of the file where the description method
        # is defined for a given class
        # @param klass [Class] the class to look up the method in
        # @return [String] the path to the source file for the class
        # @api private
        def path_to_plugin(klass)
          klass.method(:description).source_location[0]
        end

        # returns the default path to the code generator cookbook for
        # a plugin, which is a directory named 'code_generator' five
        # levels above the file which defines the plugin class
        # @param classfile [String] the path to the class source, as
        #   returned from ::path_to_plugin
        # @return [String] the path to the code_generator cookbook
        # @api private
        def default_code_generator_path(classfile)
          File.expand_path(
            File.join(
              classfile,
              '..', '..', '..', '..', '..',
              'code_generator'
            )
          )
        end

        # return the path to the code_generator cookbook that comes
        # with ChefDK
        # @return [String] the path to the code_generator cookbook
        # @api private
        def builtin_code_generator_path
          require 'rubygems'
          spec = Gem::Specification.find_by_name('chef-dk')
          File.join(
            spec.gem_dir, 'lib', 'chef-dk', 'skeletons', 'code_generator'
          )
        end
      end
    end
  end
end
