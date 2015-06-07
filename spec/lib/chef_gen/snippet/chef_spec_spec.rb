require 'chef_gen/flavors'
require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class Awesome < FlavorBase
      include ChefGen::Snippet::ChefSpec

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

# rubocop:disable Style/RegexpLiteral
RSpec.describe ChefGen::Snippet::ChefSpec do
  include ChefDKGeneratorContext
  include DummyRecipe
  include StdQuiet

  %w(spec spec/recipes).each do |dname|
    it "should create the directory #{dname}" do
      expect(@recipe).to receive(:directory).with(%r{#{dname}$})
      template = ChefGen::Flavor::Awesome.new(@recipe)
      template.generate
    end
  end

  %w(.rspec spec/spec_helper.rb spec/recipes/default_spec.rb).each do |fname|
    it "should add a template for #{fname}" do
      expect(@recipe).to receive(:template).with(%r{#{fname}$})
      template = ChefGen::Flavor::Awesome.new(@recipe)
      template.generate
    end
  end

  it 'should add the chefspec gems' do
    template = ChefGen::Flavor::Awesome.new(@recipe)
    template.generate
    expect(template.cookbook_gems.keys).to include('chefspec')
    expect(template.cookbook_gems.keys).to include('guard-rspec')
    expect(template.cookbook_gems.keys).to include('ci_reporter_rspec')
  end

  it 'should add the chefspec rake tasks' do
    template = ChefGen::Flavor::Awesome.new(@recipe)
    template.generate
    expect(template.rake_tasks.keys).to include('chefspec')
  end

  it 'should add the chefspec guard sets' do
    template = ChefGen::Flavor::Awesome.new(@recipe)
    template.generate
    expect(template.guard_sets.keys).to include('chefspec')
  end

  it 'should copy snippet contents' do
    ChefGen::Flavors.disregard_plugin :baz
    ENV['CHEFGEN_FLAVOR'] = 'Awesome'
    ChefGen::Flavors.path
  end
end
