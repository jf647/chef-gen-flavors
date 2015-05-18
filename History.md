# Changelog for chef-gen-template

## 0.4.1

* declare the target path 'directory' before running snippets, which fixes the GitInit snippet trying to run in a directory that hasn't been created yet

## 0.4.0

* added a GitInit snippet that runs 'git init .'
* added a simple Aruba tests that verifies that 'chef generate cookbook foo' works

## 0.3.0

* renamed from ChefDK::Template::Plugin to ChefGen::Flavors at Chef's request so as to not pollute the ChefDK namespace
  * 0.2.0 exists only with the old name as a transitional to remind people that the name has changed

## 0.1.0

* initial version
