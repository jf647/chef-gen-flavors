require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class Awesome < FlavorBase
      include ChefGen::Snippet::CookbookBase

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

RSpec.describe ChefGen::Snippet::CookbookBase do
  include ChefDKGeneratorContext
  include DummyRecipe

  %w(Gemfile Rakefile Berksfile Guardfile README.md
     CHANGELOG.md metadata.rb).each do |fname|
    it "should add a template for #{fname}" do
      expect(@recipe).to receive(:template).with(/#{fname}$/)
      template = ChefGen::Flavor::Awesome.new(@recipe)
      template.generate
    end
  end
end
