Given(/^a knife.rb that uses chef-gen-flavors$/) do
  write_file 'knife.rb', <<END
require 'chef_gen/flavors'
chefdk.generator_cookbook = ChefGen::Flavors.path
END
end
