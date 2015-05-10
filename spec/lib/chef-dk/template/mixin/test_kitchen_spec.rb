require 'chef-dk/template/plugin_base'
require 'chef-dk/template/mixins'

module ChefDK
  module Template
    class Plugin
      class Awesome < PluginBase
        include ChefDK::Template::Mixin::TestKitchen

        class << self
          # :nocov:
          def description
            'my awesome template'
          end
          # :nocov:
        end
      end
    end
  end
end

# rubocop:disable Style/RegexpLiteral
RSpec.describe ChefDK::Template::Mixin::TestKitchen do
  before do
    @ctx = double('ChefDK generator context')
    allow(@ctx).to receive(:cookbook_root).and_return('/nonexistent')
    allow(@ctx).to receive(:cookbook_name).and_return('foo')
    allow(ChefDK::Generator).to receive(:context).and_return(@ctx)
    @recipe = double('Chef recipe').as_null_object
  end

  %w(test test/integration test/integration/default
     test/integration/default/serverspec
     test/integration/default/serverspec/recipes).each do |dname|
    it "should create the directory #{dname}" do
      expect(@recipe).to receive(:directory).with(%r{#{dname}$})
      template = ChefDK::Template::Plugin::Awesome.new(@recipe)
      template.generate
    end
  end

  %w(.kitchen.yml test/integration/default/serverspec/spec_helper.rb
     test/integration/default/serverspec/recipes/default_spec.rb)
    .each do |fname|
    it "should add a template for #{fname}" do
      expect(@recipe).to receive(:template).with(%r{#{fname}$})
      template = ChefDK::Template::Plugin::Awesome.new(@recipe)
      template.generate
    end
  end
end
