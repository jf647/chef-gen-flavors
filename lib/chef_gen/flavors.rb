require 'tmpdir'
require 'little-plugger'

require 'chef_gen/flavor'

# chef generators
module ChefGen
  # a plugin framework for creating ChefDK generator flavors
  class Flavors
    # the version of the gem
    VERSION = '0.9.1'

    extend LittlePlugger path: 'chef_gen/flavor',
                         module: ChefGen::Flavor

    class << self
      # return the path to to the copy of the generator cookbook
      # for the selected ChefGen Flavor
      # @return [String] the path to the code_generator cookbook
      def path
        # select the plugin to use
        @plugins = plugins.dup
        add_builtin_template
        selected = plugin_from_env ||
                   only_plugin ||
                   prompt_for_plugin ||
                   fail('no ChefGen flavors found!')
        $stdout.puts "using ChefGen flavor '#{selected}'"

        # return early if we're using the builtin flavor
        return chefdk_generator_cookbook_path if :builtin == selected

        # get a temp dir
        tmpdir = create_tmpdir(selected)

        # call the content hooks in the flavor
        @plugins[selected].new(temp_path: tmpdir).add_content

        # return the temporary directory
        tmpdir
      end

      private

      # creates a temporary directory for the flavor to populate
      # @param [Symbol] flavor the selected flavor
      # @return [String] the temporary path
      # @api private
      def create_tmpdir(flavor)
        tmpdir = File.join(Dir.mktmpdir('chefgen_flavor.'), flavor.to_s)
        at_exit do
          FileUtils.rm_rf(tmpdir)
        end unless ENV.key?('CHEFGEN_NOCLEANTMP')
        tmpdir
      end

      # checks if the plugin to use has been specified in the environment
      # variable CHEFGEN_FLAVOR
      # @return [Symbol,nil] the plugin if specified and found, nil otherwise
      # @api private
      def plugin_from_env
        if ENV.key?('CHEFGEN_FLAVOR')
          candidate = ENV['CHEFGEN_FLAVOR'].downcase.to_sym
          return candidate if @plugins.key?(candidate)
        end
        nil
      end

      # if the environment variable CHEFDK_FLAVOR is defined, adds
      # the built-in template that comes with ChefDK to the list of available
      # plugins
      # @return [void]
      # @api private
      def add_builtin_template
        @plugins[:builtin] = true if ENV.key?('CHEFDK_FLAVOR')
      end

      # returns the sole installed plugin if only one is found
      # @return [Symbol,nil] the plugin if only one is installed,
      #   nil otherwise
      # @api private
      def only_plugin
        @plugins.keys.size == 1 ? @plugins.keys.first : nil
      end

      # prompts the user for a plugin to use if more than one is available
      # @return [Symbol] the selected plugin
      # @raise RuntimeError if an invalid plugin is chosen
      # @api private
      # :nocov:
      def prompt_for_plugin
        return nil unless @plugins.keys.size >= 1
        require 'bogo-ui'
        ui = Bogo::Ui.new(app_name: 'ChefGen Flavor Selector')
        valid = plugin_selection(ui)
        response = ui.ask_question('Enter selection').to_i
        return valid[response.to_i] if valid[response]
        ui.fatal 'Invalid flavor chosen'
        fail 'Invalid ChefGen Flavor'
      end
      # :nocov:

      # builds a list of plugins and displays them with as
      # a number selection list
      # @param [Bogo::Ui] ui the ui object to use for display
      # @return [Hash] a hash of valid options
      # @api private
      # :nocov:
      def plugin_selection(ui)
        output = [ui.color('Flavors on the menu', :bold)]
        idx = 1
        valid = {}
        @plugins.sort.each do |name, klass|
          valid[idx] = name
          if true == klass
            output << "#{idx}. ChefDK built-in template"
          else
            output << "#{idx}. #{name}: #{plugin_descr(klass)}"
          end
          idx += 1
        end
        ui.info "#{output.join("\n")}\n"
        valid
      end
      # :nocov:

      # builds the description of a flavor for the menu
      # @param [Class] klass the class of the flavor
      # @return [String] the flavor description with version if available
      # @api private
      # :nocov:
      def plugin_descr(klass)
        descr = klass.const_defined?(:DESC) ? klass.const_get(:DESC) : ''
        descr += " v#{klass.const_get(:VERSION, false)}" if klass.const_defined?(:VERSION)
        descr
      end
      # :nocov:

      # return the path to the code_generator cookbook that comes with ChefDK
      # @return [String] the path to the code_generator cookbook
      # @api private
      def chefdk_generator_cookbook_path
        require 'rubygems'
        spec = Gem::Specification.find_by_name('chef-dk')
        File.join(
          spec.gem_dir, 'lib', 'chef-dk', 'skeletons', 'code_generator'
        )
      end
    end
  end
end
