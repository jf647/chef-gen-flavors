module ChefDK
  module Template
    # mixins that template plugins can compose
    module Mixin
      autoload :Attributes, 'chef-dk/template/mixin/attributes'
      autoload :ChefSpec, 'chef-dk/template/mixin/chef_spec'
      autoload :CookbookBase, 'chef-dk/template/mixin/cookbook_base'
      autoload :ExampleFile, 'chef-dk/template/mixin/example_file'
      autoload :ExampleTemplate, 'chef-dk/template/mixin/example_template'
      autoload :Recipes, 'chef-dk/template/mixin/recipes'
      autoload :ResourceProvider, 'chef-dk/template/mixin/resource_provider'
      autoload :StandardIgnore, 'chef-dk/template/mixin/standard_ignore'
      autoload :StyleRubocop, 'chef-dk/template/mixin/style_rubocop'
      autoload :TestKitchen, 'chef-dk/template/mixin/test_kitchen'
    end
  end
end
