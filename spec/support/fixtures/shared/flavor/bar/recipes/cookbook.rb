c = ChefDK::Generator.context
dest_path = File.join(c.cookbook_root, c.cookbook_name)

directory dest_path

template ::File.join(dest_path, 'README.md') do
  source 'README_md.erb'
end
