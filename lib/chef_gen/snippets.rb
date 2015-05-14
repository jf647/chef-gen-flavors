module ChefGen
  # template snippets that flavors can compose to do common things
  module Snippet
    autoload :Attributes, 'chef_gen/snippet/attributes'
    autoload :ChefSpec, 'chef_gen/snippet/chef_spec'
    autoload :CookbookBase, 'chef_gen/snippet/cookbook_base'
    autoload :ExampleFile, 'chef_gen/snippet/example_file'
    autoload :ExampleTemplate, 'chef_gen/snippet/example_template'
    autoload :Recipes, 'chef_gen/snippet/recipes'
    autoload :ResourceProvider, 'chef_gen/snippet/resource_provider'
    autoload :StandardIgnore, 'chef_gen/snippet/standard_ignore'
    autoload :StyleRubocop, 'chef_gen/snippet/style_rubocop'
    autoload :TestKitchen, 'chef_gen/snippet/test_kitchen'
  end
end
