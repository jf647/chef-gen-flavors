require 'chef_gen/flavors'
require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class Awesome < FlavorBase
      include ChefGen::Snippet::StyleRubocop

      # :nocov:
      def self.description
        'my awesome template'
      end
      # :nocov:

      def self.code_generator_path(classfile)
        File.expand_path(
          File.join(
            classfile,
            '..', '..', '..', '..',
            'support', 'fixtures', 'code_generator'
          )
        )
      end
    end
  end
end

RSpec.describe ChefGen::Snippet::StyleRubocop do
  include ChefDKGeneratorContext
  include DummyRecipe
  include StdQuiet

  %w(.rubocop.yml).each do |fname|
    it "should add a template for #{fname}" do
      expect(@recipe).to receive(:template).with(/#{fname}$/)
      template = ChefGen::Flavor::Awesome.new(@recipe)
      template.generate
    end
  end

  it 'should add the rubocop gems' do
    template = ChefGen::Flavor::Awesome.new(@recipe)
    template.generate
    expect(template.cookbook_gems.keys).to include('rubocop')
    expect(template.cookbook_gems.keys).to include('guard-rubocop')
  end

  it 'should add the rubocop rake tasks' do
    template = ChefGen::Flavor::Awesome.new(@recipe)
    template.generate
    expect(template.rake_tasks.keys).to include('rubocop')
  end

  it 'should add the rubocop guard sets' do
    template = ChefGen::Flavor::Awesome.new(@recipe)
    template.generate
    expect(template.guard_sets.keys).to include('rubocop')
  end

  it 'should copy snippet contents' do
    ChefGen::Flavors.disregard_plugin :baz
    ENV['CHEFGEN_FLAVOR'] = 'Awesome'
    ChefGen::Flavors.path
  end
end
