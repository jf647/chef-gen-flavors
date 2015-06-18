# Changelog for chef-gen-flavors

## 0.8.2

* TestKitchen snippet: require the TK rake tasks inside the rescue block so that if we blow up because vagrant isn't installed, we can recover

## 0.8.1

* CookbookBase snippet: disable the line length cop in Gemfile via .rubocop.yml instead of via an inline comment

## 0.8.0

* give snippets the ability to use the add_render to construct resources with additional attributes
* add local override inclusion for Gemfile, Berksfile and Guardfile to snippets
* allow the CookbookBase snippet's @cookbook_gems hash to take an String or Array value.  A string is a constraint, an Array is a constraint plus 0..n extra args (like a git source)

## 0.7.0

Major re-organization around snippets

* the code generator cookbook is now copied to a temporary directory that snippets can augment
* snippets can therefore write content as well as file declarations.  All of the core snippets have been enhanced to do this, so the example cookbook is now tiny.
* add hooks for snippets to initialize themselves
* add a hook after all snippets have run in case mods want to rewind or undo things that other snippets have done
* add the version of the flavor to the description in the menu
* enhance the cookbook base snippet to allow the Rakefile to be composed of content from other snippets
* enhance the cookbook base snippet to allow the Gemfile to be composed of content from other snippets
* enhance the cookbook base snippet to allow the Guardfile to be composed of content from other snippets
* move the chefignore/gitignore accumulators out of FlavorBase and into the StandardIgnore snippet
* extract FoodCritic to its own snippet
* add a StyleTailor snippet

## 0.6.2

* sort flavors alphabetically (suggested by @echohack)

## 0.6.1

* remove leftover debugging statements about copy of generator cookbook

## 0.6.0

* copy the contents of the code generator to a temporary path.  This is foundational work for allow snippets to include content as well as resource declarations

## 0.5.0

* provide some helpful Aruba step definitions for flavors to use in feature tests

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
