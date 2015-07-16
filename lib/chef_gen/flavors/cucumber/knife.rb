Given(/^a knife.rb that uses chef-gen-flavors$/) do
  write_file 'knife.rb', <<END
cookbook_path '#{File.expand_path(current_dir)}'
require 'chef_gen/flavors'
chefdk.generator_cookbook = ChefGen::Flavors.path
END
end
