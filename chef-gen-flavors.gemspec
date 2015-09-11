# -*- encoding: utf-8 -*-
# stub: chef-gen-flavors 0.9.1.20150911132844 ruby lib

Gem::Specification.new do |s|
  s.name = "chef-gen-flavors"
  s.version = "0.9.1.20150911132844"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["James FitzGibbon"]
  s.date = "2015-09-11"
  s.description = "chef-gen-flavors is a framework for creating custom templates for the\n'chef generate' command provided by ChefDK.\n\nThis gem simply provides a framework; templates are provided by separate\ngems, which you can host privately for use within your organization or\npublicly for the Chef community to use.\n\n[chef-gen-flavor-base](https://github.com/jf647/chef-gen-flavor-base) is\na base class that makes it easy to compose a flavor from reusable\nsnippets of functionality, and using it is highly recommended.  Using\nchef-gen-flavors on its own is only suitable if you already have a\ntemplate which is a copy of the skeleton provided by ChefDK.\n\nAt present this is focused primarily on providing templates for\ngeneration of cookbooks, as this is where most organization-specific\ncustomization takes place. Support for the other artifacts that ChefDK\ncan generate may work, but is not the focus of early releases."
  s.email = ["james@nadt.net"]
  s.extra_rdoc_files = ["ARUBA_STEPS.md", "History.md", "Manifest.txt", "README.md"]
  s.files = ["ARUBA_STEPS.md", "History.md", "LICENSE", "Manifest.txt", "README.md", "chef-gen-flavors.gemspec", "lib/chef_gen/flavor.rb", "lib/chef_gen/flavors.rb", "lib/chef_gen/flavors/cucumber.rb", "lib/chef_gen/flavors/cucumber/bundle.rb", "lib/chef_gen/flavors/cucumber/chefdk.rb", "lib/chef_gen/flavors/cucumber/kitchen.rb", "lib/chef_gen/flavors/cucumber/knife.rb", "lib/chef_gen/flavors/cucumber/rake.rb", "lib/chef_gen/flavors/cucumber/regex.rb"]
  s.homepage = "https://github.com/jf647/chef-gen-flavors"
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
      s.add_development_dependency(%q<chef-dk>, ["~> 0.7"])
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
      s.add_development_dependency(%q<aruba>, ["~> 0.6.2"])
      s.add_development_dependency(%q<rspec_junit_formatter>, ["~> 0.2"])
      s.add_development_dependency(%q<fakefs>, ["~> 0.6"])
    else
      s.add_dependency(%q<little-plugger>, ["~> 1.1"])
      s.add_dependency(%q<bogo-ui>, ["~> 0.1"])
      s.add_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_dependency(%q<chef-dk>, ["~> 0.7"])
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
      s.add_dependency(%q<aruba>, ["~> 0.6.2"])
      s.add_dependency(%q<rspec_junit_formatter>, ["~> 0.2"])
      s.add_dependency(%q<fakefs>, ["~> 0.6"])
    end
  else
    s.add_dependency(%q<little-plugger>, ["~> 1.1"])
    s.add_dependency(%q<bogo-ui>, ["~> 0.1"])
    s.add_dependency(%q<rdoc>, ["~> 4.0"])
    s.add_dependency(%q<chef-dk>, ["~> 0.7"])
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
    s.add_dependency(%q<aruba>, ["~> 0.6.2"])
    s.add_dependency(%q<rspec_junit_formatter>, ["~> 0.2"])
    s.add_dependency(%q<fakefs>, ["~> 0.6"])
  end
end
