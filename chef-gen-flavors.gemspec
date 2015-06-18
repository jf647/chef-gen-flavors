# -*- encoding: utf-8 -*-
# stub: chef-gen-flavors 0.8.1.20150618142659 ruby lib

Gem::Specification.new do |s|
  s.name = "chef-gen-flavors"
  s.version = "0.8.1.20150618142659"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["James FitzGibbon"]
  s.date = "2015-06-18"
  s.description = "chef-gen-flavors is a framework for creating custom templates for the\n'chef generate' command provided by ChefDK.\n\nThis gem simply provides a framework; templates are provided by separate\ngems, which you can host privately for use within your organization or\npublicly for the Chef community to use.\n\nAt present this is focused primarily on providing templates for generation of\ncookbooks, as this is where most organization-specific customization takes place.\nSupport for the other artifacts that ChefDK can generate may work, but is not\nthe focus of early releases."
  s.email = ["james.i.fitzgibbon@nordstrom.com"]
  s.extra_rdoc_files = ["ARUBA_STEPS.md", "History.md", "Manifest.txt", "README.md"]
  s.files = ["ARUBA_STEPS.md", "History.md", "LICENSE", "Manifest.txt", "README.md", "chef-gen-flavors.gemspec", "lib/chef_gen/flavor.rb", "lib/chef_gen/flavor_base.rb", "lib/chef_gen/flavors.rb", "lib/chef_gen/flavors/cucumber.rb", "lib/chef_gen/flavors/cucumber/bundle.rb", "lib/chef_gen/flavors/cucumber/chefdk.rb", "lib/chef_gen/flavors/cucumber/kitchen.rb", "lib/chef_gen/flavors/cucumber/knife.rb", "lib/chef_gen/flavors/cucumber/rake.rb", "lib/chef_gen/flavors/cucumber/regex.rb", "lib/chef_gen/snippet/attributes.rb", "lib/chef_gen/snippet/chef_spec.rb", "lib/chef_gen/snippet/cookbook_base.rb", "lib/chef_gen/snippet/example_file.rb", "lib/chef_gen/snippet/example_template.rb", "lib/chef_gen/snippet/git_init.rb", "lib/chef_gen/snippet/recipes.rb", "lib/chef_gen/snippet/resource_provider.rb", "lib/chef_gen/snippet/standard_ignore.rb", "lib/chef_gen/snippet/style_foodcritic.rb", "lib/chef_gen/snippet/style_rubocop.rb", "lib/chef_gen/snippet/style_tailor.rb", "lib/chef_gen/snippet/test_kitchen.rb", "lib/chef_gen/snippets.rb", "shared/snippet/attributes/attributes_default_rb.erb", "shared/snippet/chef_spec/_rspec.erb", "shared/snippet/chef_spec/spec_chef_runner_context_rb.erb", "shared/snippet/chef_spec/spec_recipes_default_spec_rb.erb", "shared/snippet/chef_spec/spec_spec_helper_rb.erb", "shared/snippet/cookbookbase/Berksfile.erb", "shared/snippet/cookbookbase/CHANGELOG_md.erb", "shared/snippet/cookbookbase/Gemfile.erb", "shared/snippet/cookbookbase/Guardfile.erb", "shared/snippet/cookbookbase/README_md.erb", "shared/snippet/cookbookbase/Rakefile.erb", "shared/snippet/cookbookbase/metadata_rb.erb", "shared/snippet/examplefile/files_default_example_conf", "shared/snippet/exampletemplate/templates_default_example_conf_erb", "shared/snippet/recipes/recipes_default_rb.erb", "shared/snippet/resourceprovider/providers_default_rb.erb", "shared/snippet/resourceprovider/resources_default_rb.erb", "shared/snippet/stylerubocop/_rubocop_yml.erb", "shared/snippet/testkitchen/_kitchen_yml.erb", "shared/snippet/testkitchen/libraries_kitchen_helper_rb", "shared/snippet/testkitchen/test_integration_default_serverspec_recipes_default_spec_rb.erb", "shared/snippet/testkitchen/test_integration_default_serverspec_spec_helper_rb.erb"]
  s.homepage = "https://github.com/Nordstrom/chef-gen-flavors"
  s.licenses = ["apache2"]
  s.rdoc_options = ["--main", "README.md"]
  s.rubygems_version = "2.4.4"
  s.summary = "chef-gen-flavors is a framework for creating custom templates for the 'chef generate' command provided by ChefDK"

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
      s.add_development_dependency(%q<aruba>, ["~> 0.6"])
      s.add_development_dependency(%q<rspec_junit_formatter>, ["~> 0.2"])
      s.add_development_dependency(%q<fakefs>, ["~> 0.6"])
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
      s.add_dependency(%q<aruba>, ["~> 0.6"])
      s.add_dependency(%q<rspec_junit_formatter>, ["~> 0.2"])
      s.add_dependency(%q<fakefs>, ["~> 0.6"])
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
    s.add_dependency(%q<aruba>, ["~> 0.6"])
    s.add_dependency(%q<rspec_junit_formatter>, ["~> 0.2"])
    s.add_dependency(%q<fakefs>, ["~> 0.6"])
  end
end
