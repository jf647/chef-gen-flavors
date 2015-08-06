# Changelog for chef-gen-flavors

## 0.8.6

This version contains no code changes; this is a courtesy version bump
because breaking API changes are coming in v0.9.x.  If you have a flavor
that derives from ChefGen::FlavorBase, you may want to pin to '~> 0.8.6'
to insulate yourself from these changes.

A brief synopsis of what's planned:

* extract FlavorBase from this gem into it's own distribution
  * possibly extract the standard snippets into their own distribution as well for those who want the framework without anything extra
* change the way snippets are added to flavors to be by declaration rather than composition (i.e. you'll call something like `::mixin(Snippet)` rather than `include Snippet`)

These changes are to support guaranteed ordering of snippet contents.
Right now if you want everything that say ChefGen::Snippet::TestKitchen
provides but want to override just the .kitchen.yml file, you have to do
silly tricks where your replacement template is added by a method that
lexically sorts after `content_testkitchen_files`.  This is not a solid
design, and I'm taking the opportunity to fix it while we're still at
major version 0.

## 0.8.5

* pin to Aruba 0.6.x because of the incompatible changes in subprocess working directories introduced in 0.7
* revert 'current_dir' change in 0.8.4, which was only required due to upgrading Aruba

## 0.8.4
* Specify minimum `berkshelf` version of '3.3' in generated Gemfile. Berkshelf
3.3+ support `no_proxy` env var so you can download from Public and private
supermarket sources in your Berksfile.

## 0.8.3

* TestKitchen snippet: give the dummy task created when TK cannot initalize (e.g. vagrant not installed) a description so it shows up in the output of 'rake -T'

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
