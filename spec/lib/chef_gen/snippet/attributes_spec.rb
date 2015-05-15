require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class Awesome < FlavorBase
      include ChefGen::Snippet::Attributes

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

# rubocop:disable Style/RegexpLiteral
RSpec.describe ChefGen::Snippet::Attributes do
  include ChefDKGeneratorContext
  include DummyRecipe

  %w(attributes).each do |dname|
    it "should create the directory #{dname}" do
      expect(@recipe).to receive(:directory).with(%r{#{dname}$})
      template = ChefGen::Flavor::Awesome.new(@recipe)
      template.generate
    end
  end

  %w(attributes/default.rb).each do |fname|
    it "should add a template for #{fname}" do
      expect(@recipe).to receive(:template).with(%r{#{fname}$})
      template = ChefGen::Flavor::Awesome.new(@recipe)
      template.generate
    end
  end
end
