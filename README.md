# chef-dk-template-plugin

* home :: https://github.com/Nordstrom/chef-dk-template-plugin
* license :: [Apache2](http://www.apache.org/licenses/LICENSE-2.0)
* gem version :: [![Gem Version](https://badge.fury.io/rb/chef-dk-template-plugin.png)](http://badge.fury.io/rb/chef-dk-template-plugin)
* build status :: [![Build Status](https://travis-ci.org/Nordstrom/chef-dk-template-plugin.png?branch=master)](https://travis-ci.org/Nordstrom/chef-dk-template-plugin)
* code climate :: [![Code Climate](https://codeclimate.com/github/Nordstrom/chef-dk-template-plugin/badges/gpa.svg)](https://codeclimate.com/github/Nordstrom/chef-dk-template-plugin)

## DESCRIPTION

chef-dk-template-plugin is a framework for creating custom templates for the
'chef generate' command provided by ChefDK.

This gem simply provides a framework; templates are provided by separate
gems, which you can host privately for use within your organization or
publically for the Chef community to use.

At present this is focused primarily on providing templates for generation of
cookbooks, as this is where most organization-specific customization takes place.
Support for the other artifacts that ChefDK can generate may work, but is not
the focus of early releases.

## INSTALLATION

    chef gem install chef-dk-template-plugin

You will also need to install at least one plugin, which may be distributed
via Rubygems (in which case you install using `chef gem`) or as source, in
which case you should refer to the installation documentation that comes with
the plugin.

## PREREQUISITES

This gem requires that you have [ChefDK](https://downloads.chef.io/chef-dk/)
(at least version 0.3.6) installed. chef-dk is not a dependency of this gem
because chef-dk should always be installed using the omnibus packages
provided by Chef, not as a gem.

## CONFIGURATION

In your `knife.rb` file, add this snippet:

    unless chefdk.nil?
      require 'chef-dk/template/plugin'
      chefdk.generator_cookbook = ChefDK::Template::Plugin.path
    end

When you run `chef generate`, all available plugins will be loaded. If more
than one plugin is found, you will be prompted as to which you want to use:

    $ chef generate cookbook my_app

If you set the environment variable `CHEFDK_TEMPLATE` to the name of a
plugin, it will be chosen instead of presenting a prompt:

    $ CHEFDK_TEMPLATE=mytemplate chef generate cookbook my_app

## USING THE BUILT-IN CHEFDK TEMPLATE

By default, this gem does not offer the built-in ChefDK template as an
option.  By setting the environment variable CHEFDK_TEMPLATE_BUILTIN, the
option `builtin` will be offered.

## PLUGINS

This gem uses [little-plugger](https://rubygems.org/gems/little-plugger) to
make adding template flavors easy. Each flavor is defined by a plugin named
using [little-pluggers's
rules](https://github.com/TwP/little-plugger/blob/little-plugger-1.1.2/lib/little-plugger.rb#L13-25).

The plugin must define a class inside the naming hierarchy
`ChefDK::Template::`. The class name should be the filename converted to
CamelCase (e.g. `foo_bar.rb` = `FooBar`)

The name of the module must not be in all caps, as little-plugger ignores
these (assuming that they are constants).

Plugins must also define a class method named `description`, which is used
both to find the path to the file that defines the plugin and in the prompt
displayed when more than one plugin is available.

You do not have to `require` your plugin; little-plugger searches all
installed gems for files matching the globspec.

## EXAMPLE PLUGIN STRUCTURE

This example defines a plugin named `Example`. It can only generate
cookbooks, as its code_generator cookbook contains no other recipes.

A functional copy of this plugin is available on rubygems as
`chef-dk-template-example`.

The directory structure of a plugin looks like this:

    chef-dk-template-example
    ├── code_generator
    │   ├── files
    │   │   └── default
    │   ├── metadata.rb
    │   ├── recipes
    │   │   └── cookbook.rb
    │   └── templates
    │       └── default
    └── lib
        └── chef-dk
            └── template
                └── plugin
                    └── example.rb

## ALTERNATE code_generator PATHS

By default, the code_generator cookbook is assumed to live in a directory
named `code_generator` five levels higher than the path of the file
definining the plugin.

To specify that the code_generator cookbook lives elsewhere, define a class
method named `code_generator_path` which takes one argument (the path to the
plugin class) and returns the path to the code_generator cookbook. If the
`Example` plugin wanted to place the code_generator cookbook in a directory
named `template` instead of `code_generator`, it would define an instance
method like this:

    module ChefDK
      module Template
        class Plugin
          class Example
            class << self
              def description
                'example cookbook template'
              end

              def code_generator_path(classfile)
                File.expand_path(
                  File.join(
                    classfile,
                    '..', '..', '..', '..',
                    'template'
                  )
                )
              end
            end
          end
        end
      end
    end

For compatibility with all platforms supported by ChefDK, plugins should use
the methods in the `File` class to construct relative paths rather than
assuming what the path separator should be.

## PLUGIN BASE CLASS

Inside of your plugin's code_generator cookbook, you can do anything that
chef-solo can do. If you aren't familiar with the mechanics of the default
generators that comes with chef-dk, you should study [those
recipes](https://github.com/chef/chef-dk/tree/0.5.1/lib/chef-dk/skeletons/code_generator)
first before attempting to create your own.

To make the job of authoring a custom template easier, this gem comes with a
base class that plugins can inherit from. This provides some useful
features:

* helpers to create directories and render files and templates using simple name translation
* the ability to create and use mixins that set up commonly used functionality (i.e. ChefSpec or Test Kitchen)
* the ability to prevent files from being overwritten when a template is being applied overtop an existing cookbook

To use the base class, make it a dependency of your gem and inherit from it:

    require 'chef-dk/template/plugin_base'

    module ChefDK
      module Template
        class Plugin
          class Amazing < PluginBase
          end
        end
      end
    end

Then in one of your generator recipes like `recipes/cookbook.rb`, create
an instance of your plugin, passing the recipe into which resources will
be injected:

    template = ChefDK::Template::Plugin::Amazing.new(self)

The plugin has several helper methods you can use:

* `target_path` returns the full path to the target directory
* `directories` is a `Array` of directories to create
* `files` is an `Array` of files to create
* `files_if_missing` is an `Array` of files to create which should not be overwritten if they exist
* `templates` is an `Array` of templates to render
* `templates_if_missing` is an `Array` of templates to render which should not be overwritten if they exist
* `chefignore_files` is an `Array` of glob patterns to write to the `chefignore` file.  If this array is empty, the file is not created automatically (but templates can take this on themselves)
* `gitignore_files` is an `Array` of glob patterns to write to the `.gitignore` file.  If this array is empty, the file is not created automatically (but templates can take this on themselves)
* `fail_on_clobber` is a boolean accessor which causes generation to fail if any files in the `files` or `templates` arrays already exist.  Defaults to true, but can be set to false by adding `-a clobber` to the `chef generate` command line
* `report_actions` is a boolean accessor which causes the generator to report all of the actions it took
* `next_steps` is a message to be displayed to the user as the last thing the generator does

The distinction between files that are overwritten and those that are
created only if they do not exist allows for updating a cookbook to an
organization-wide policy while still allowing for per-cookbook
customization.

For example, if your cookbook template has a standard Rakefile and you wish
to add a target to it, you can do so if Rakefile is in the `files` array.
When the generator is used on top of an existing cookbook, the Rakefile will
be rewritten. Custom rake tasks can be placed in `.rake` files in the
directory `lib/tasks`, which will not be overwritten.

Once the template object has been set up to your satisfaction, call the
`#generate` method, which creates the Chef resources to generate your
target.

The list of files and templates take the path to the rendered file (e.g.
`spec/spec_helper.rb`). The source for the file or template will be
transformed by replacing foreward slashes and dots with underscores.
Additionally, templates have `.erb` appended to the source.

This code:

    template = ChefDK::Template::Plugin::Amazing.new
    template.files << 'spec/spec_helper.rb'
    template.templates << '.rubocop.yml'
    template.generate

is equivalent to manually creating these resources:

    file "#{cookbook_dir}/spec/spec_helper.rb" do
      source 'spec_spec_helper_rb'
    end

    template "#{cookbook_dir}/.rubocop.yml" do
      source '_rubocop_yml.erb'
    end

### TEMPLATE MIXINS

Many templates will use common patterns, such as providing a README.md and
CHANGELOG.md, providing the files necessary to create a ChefSpec unit
testing suite, or the files necessary to create a Test Kitchen integration
testing suite.

Rather than have every template author create these, this gem ships with a
number of mixins, which can be included in your plugin class like so:

    require 'chef-dk/template/plugin_base'
    require 'chef-dk/template/mixins'

    module ChefDK
      module Template
        class Plugin
          class Amazing < PluginBase
            include ChefDK::Template::Mixin::ChefSpec
          end
        end
      end
    end

The mixins that ship with this gem are:

* `CookbookBase` - sets up the basic files any cookbook needs (README, CHANGELOG, etc.)
* `StyleRubocop` - sets up the files for style checking with Rubocop
* `ChefSpec` - sets up the files for basic ChefSpec unit testing
* `TestKitchen` - sets up the files for basic Test Kitchen integration testing
* `Recipes` - creates recipes/default.rb
* `Attributes` - creates attributes/default.rb
* `ExampleFile` - creates files/default/example.conf
* `ExampleTemplate` - creates templates/default/example.conf.erb
* `ResourceProvider` - sets up a sample LWRP resource and provider

You can also create your own mixins. A mixin is simply a module that
provides some number of public methods prefixed with `mixin\_`. Any such
methods will be called, passing the recipe object as the only parameter when
`#generate` is called. For example, a simplified ChefSpec mixin might look
like this:

    module ChefDK
      module Template
        module Mixin
          module ChefSpec
            def mixin_chefspec(recipe)
              @directories << 'spec'
              @directories << File.join('spec', '/recipes')
              @files << '.rspec'
              @files << File.join('spec', 'spec_helper.rb')
              @files << File.join('spec', 'recipes', 'default_spec.rb')
            end
          end
        end
      end
    end

## AUTHOR

James FitzGibbon - james.i.fitzgibbon@nordstrom.com - Nordstrom, Inc.

## LICENSE

Copyright 2015 Nordstrom, Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not
use this file except in compliance with the License. You may obtain a copy
of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
License for the specific language governing permissions and limitations
under the License.
