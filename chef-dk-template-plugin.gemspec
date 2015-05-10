# -*- encoding: utf-8 -*-
# stub: chef-dk-template-plugin 0.1.0.20150511170212 ruby lib

Gem::Specification.new do |s|
  s.name = "chef-dk-template-plugin"
  s.version = "0.1.0.20150511170212"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["James FitzGibbon"]
  s.date = "2015-05-12"
  s.description = "chef-dk-template-plugin is a framework for creating custom templates for the\n'chef generate' command provided by ChefDK.\n\nThis gem simply provides a framework; templates are provided by separate\ngems, which you can host privately for use within your organization or\npublically for the Chef community to use.\n\nAt present this is focused primarily on providing templates for generation of\ncookbooks, as this is where most organization-specific customization takes place.\nSupport for the other artifacts that ChefDK can generate may work, but is not\nthe focus of early releases."
  s.email = ["james.i.fitzgibbon@nordstrom.com"]
  s.extra_rdoc_files = ["History.md", "Manifest.txt", "README.md"]
  s.files = [".rspec", ".rubocop.yml", ".travis.yml", "Gemfile", "Gemfile.lock", "Guardfile", "History.md", "LICENSE", "Manifest.txt", "README.md", "Rakefile", "chef-dk-template-plugin.gemspec", "lib/chef-dk/template/mixin/attributes.rb", "lib/chef-dk/template/mixin/chef_spec.rb", "lib/chef-dk/template/mixin/cookbook_base.rb", "lib/chef-dk/template/mixin/example_file.rb", "lib/chef-dk/template/mixin/example_template.rb", "lib/chef-dk/template/mixin/recipes.rb", "lib/chef-dk/template/mixin/resource_provider.rb", "lib/chef-dk/template/mixin/standard_ignore.rb", "lib/chef-dk/template/mixin/style_rubocop.rb", "lib/chef-dk/template/mixin/test_kitchen.rb", "lib/chef-dk/template/mixins.rb", "lib/chef-dk/template/plugin.rb", "lib/chef-dk/template/plugin_base.rb", "spec/lib/chef-dk/template/mixin/attributes_spec.rb", "spec/lib/chef-dk/template/mixin/chef_spec_spec.rb", "spec/lib/chef-dk/template/mixin/cookbook_base_spec.rb", "spec/lib/chef-dk/template/mixin/example_file_spec.rb", "spec/lib/chef-dk/template/mixin/example_template_spec.rb", "spec/lib/chef-dk/template/mixin/recipes_spec.rb", "spec/lib/chef-dk/template/mixin/resource_provider_spec.rb", "spec/lib/chef-dk/template/mixin/standard_ignore_spec.rb", "spec/lib/chef-dk/template/mixin/style_rubocop_spec.rb", "spec/lib/chef-dk/template/mixin/test_kitchen_spec.rb", "spec/lib/chef-dk/template/plugin_base_spec.rb", "spec/lib/chef-dk/template/plugin_spec.rb", "spec/spec_helper.rb", "spec/support/fixtures/code_generator/metadata.rb", "spec/support/fixtures/code_generator/recipes/cookbook.rb", "spec/support/fixtures/code_generator_2/metadata.rb", "spec/support/fixtures/code_generator_2/recipes/cookbook.rb", "spec/support/fixtures/lib/chef-dk/template/plugin/bar.rb", "spec/support/fixtures/lib/chef-dk/template/plugin/baz.rb", "spec/support/fixtures/lib/chef-dk/template/plugin/foo.rb"]
  s.homepage = "https://github.com/Nordstrom/chef-dk-template-plugin"
  s.licenses = ["apache2"]
  s.rdoc_options = ["--main", "README.md"]
  s.rubygems_version = "2.4.4"
  s.summary = "chef-dk-template-plugin is a framework for creating custom templates for the 'chef generate' command provided by ChefDK"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<little-plugger>, ["~> 1.1"])
      s.add_runtime_dependency(%q<bogo-ui>, ["~> 0.1"])
      s.add_development_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_development_dependency(%q<chef-dk>, ["~> 0.5"])
      s.add_development_dependency(%q<hoe>, ["~> 3.13"])
      s.add_development_dependency(%q<hoe-gemspec>, ["~> 1.0"])
      s.add_development_dependency(%q<rake>, ["~> 10.3"])
      s.add_development_dependency(%q<rspec>, ["~> 3.1"])
      s.add_development_dependency(%q<guard>, ["~> 2.12"])
      s.add_development_dependency(%q<guard-rspec>, ["~> 4.2"])
      s.add_development_dependency(%q<guard-rake>, ["~> 0.0"])
      s.add_development_dependency(%q<guard-rubocop>, ["~> 1.2"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.9"])
      s.add_development_dependency(%q<simplecov-console>, ["~> 0.2"])
      s.add_development_dependency(%q<yard>, ["~> 0.8"])
    else
      s.add_dependency(%q<little-plugger>, ["~> 1.1"])
      s.add_dependency(%q<bogo-ui>, ["~> 0.1"])
      s.add_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_dependency(%q<chef-dk>, ["~> 0.5"])
      s.add_dependency(%q<hoe>, ["~> 3.13"])
      s.add_dependency(%q<hoe-gemspec>, ["~> 1.0"])
      s.add_dependency(%q<rake>, ["~> 10.3"])
      s.add_dependency(%q<rspec>, ["~> 3.1"])
      s.add_dependency(%q<guard>, ["~> 2.12"])
      s.add_dependency(%q<guard-rspec>, ["~> 4.2"])
      s.add_dependency(%q<guard-rake>, ["~> 0.0"])
      s.add_dependency(%q<guard-rubocop>, ["~> 1.2"])
      s.add_dependency(%q<simplecov>, ["~> 0.9"])
      s.add_dependency(%q<simplecov-console>, ["~> 0.2"])
      s.add_dependency(%q<yard>, ["~> 0.8"])
    end
  else
    s.add_dependency(%q<little-plugger>, ["~> 1.1"])
    s.add_dependency(%q<bogo-ui>, ["~> 0.1"])
    s.add_dependency(%q<rdoc>, ["~> 4.0"])
    s.add_dependency(%q<chef-dk>, ["~> 0.5"])
    s.add_dependency(%q<hoe>, ["~> 3.13"])
    s.add_dependency(%q<hoe-gemspec>, ["~> 1.0"])
    s.add_dependency(%q<rake>, ["~> 10.3"])
    s.add_dependency(%q<rspec>, ["~> 3.1"])
    s.add_dependency(%q<guard>, ["~> 2.12"])
    s.add_dependency(%q<guard-rspec>, ["~> 4.2"])
    s.add_dependency(%q<guard-rake>, ["~> 0.0"])
    s.add_dependency(%q<guard-rubocop>, ["~> 1.2"])
    s.add_dependency(%q<simplecov>, ["~> 0.9"])
    s.add_dependency(%q<simplecov-console>, ["~> 0.2"])
    s.add_dependency(%q<yard>, ["~> 0.8"])
  end
end
