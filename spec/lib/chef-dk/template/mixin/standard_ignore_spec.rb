require 'chef-dk/template/plugin_base'
require 'chef-dk/template/mixins'

module ChefDK
  module Template
    class Plugin
      class Awesome < PluginBase
        include ChefDK::Template::Mixin::StandardIgnore

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

RSpec.describe ChefDK::Template::Mixin::StandardIgnore do
  before do
    @ctx = double('ChefDK generator context')
    allow(@ctx).to receive(:cookbook_root).and_return('/nonexistent')
    allow(@ctx).to receive(:cookbook_name).and_return('foo')
    allow(ChefDK::Generator).to receive(:context).and_return(@ctx)
    @recipe = double('Chef recipe').as_null_object
  end

  it 'should create a chefignore file' do
    expect(@recipe).to receive(:file).with(/chefignore$/)
    template = ChefDK::Template::Plugin::Awesome.new(@recipe)
    template.generate
  end

  it 'should create a .gitignore file' do
    expect(@recipe).to receive(:file).with(/\.gitignore$/)
    template = ChefDK::Template::Plugin::Awesome.new(@recipe)
    template.generate
  end
end
