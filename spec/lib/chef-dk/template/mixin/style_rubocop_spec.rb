require 'chef-dk/template/plugin_base'
require 'chef-dk/template/mixins'

module ChefDK
  module Template
    class Plugin
      class Awesome < PluginBase
        include ChefDK::Template::Mixin::StyleRubocop

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

RSpec.describe ChefDK::Template::Mixin::StyleRubocop do
  before do
    @ctx = double('ChefDK generator context')
    allow(@ctx).to receive(:cookbook_root).and_return('/nonexistent')
    allow(@ctx).to receive(:cookbook_name).and_return('foo')
    allow(ChefDK::Generator).to receive(:context).and_return(@ctx)
    @recipe = double('Chef recipe').as_null_object
  end

  %w(.rubocop.yml).each do |fname|
    it "should add a template for #{fname}" do
      expect(@recipe).to receive(:template).with(/#{fname}$/)
      template = ChefDK::Template::Plugin::Awesome.new(@recipe)
      template.generate
    end
  end
end
