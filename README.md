# chef-gen-flavors

* home :: https://github.com/jf647/chef-gen-flavors
* license :: [Apache2](http://www.apache.org/licenses/LICENSE-2.0)
* gem version :: [![Gem Version](https://badge.fury.io/rb/chef-gen-flavors.png)](http://badge.fury.io/rb/chef-gen-flavors)
* build status :: [![Circle CI](https://circleci.com/gh/jf647/chef-gen-flavors.svg?style=svg)](https://circleci.com/gh/jf647/chef-gen-flavors)
* code climate :: [![Code Climate](https://codeclimate.com/github/jf647/chef-gen-flavors/badges/gpa.svg)](https://codeclimate.com/github/jf647/chef-gen-flavors)
* docs :: [![Inline docs](http://inch-ci.org/github/jf647/chef-gen-flavors.svg?branch=master)](http://inch-ci.org/github/jf647/chef-gen-flavors)

## DESCRIPTION

chef-gen-flavors is a framework for creating custom templates for the
'chef generate' command provided by ChefDK.

This gem simply provides a framework; templates are provided by separate
gems, which you can host privately for use within your organization or
publicly for the Chef community to use.

At present this is focused primarily on providing templates for generation of
cookbooks, as this is where most organization-specific customization takes place.
Support for the other artifacts that ChefDK can generate may work, but is not
the focus of early releases.

## INSTALLATION

    chef gem install chef-gen-flavors

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

    # only load ChefGen::Flavors if we're being called from the ChefDK CLI
    if defined?(ChefDK::CLI)
      require 'chef_gen/flavors'
      chefdk.generator_cookbook = ChefGen::Flavors.path
    end

When you run `chef generate`, all available plugins will be loaded. If more
than one plugin is found, you will be prompted as to which you want to use:

    $ chef generate cookbook my_app

If you set the environment variable `CHEFGEN_FLAVOR` to the name of a
plugin, it will be chosen instead of presenting a prompt:

    $ CHEFGEN_FLAVOR=mytemplate chef generate cookbook my_app

## USING THE BUILT-IN CHEFDK TEMPLATE

By default, this gem does not offer the built-in ChefDK template as an
option. By setting the environment variable CHEFDK_FLAVOR, the
option `builtin` will be offered.

## TERMINOLOGY

(because everything in the Chef ecosystem has to have foodie names)

* Flavor - a type of template.  Provided by a plugin in the namespace `ChefGen::Flavor::`.  Flavors can be distributed as ruby gems inside or outside of your organization.
* Snippet - a small piece of a code_generator cookbook that flavors can compose together to avoid repeating themselves.  Nominally provided by a module in the namespace `ChefGen::Snippet::`, but can be defined in any module.  chef-gen-flavors comes with several common snippets, but you can create your own and package them as standalone gems or as part of a flavor gem

## FLAVORS

This gem uses [little-plugger](https://rubygems.org/gems/little-plugger) to
make adding template flavors easy. Each flavor is defined by a plugin named
using [little-pluggers's
rules](https://github.com/TwP/little-plugger/blob/little-plugger-1.1.2/lib/little-plugger.rb#L13-25).

The plugin must define a class inside the naming hierarchy
`ChefGen::Flavor::`. The class name should be the filename converted to
CamelCase (e.g. `foo_bar.rb` = `FooBar`)

The name of the module must not be in all caps, as little-plugger ignores
these (assuming that they are constants).

Plugins must also define a class method named `description`, which is used
both to find the path to the file that defines the plugin and in the prompt
displayed when more than one plugin is available.

You do not have to `require` your plugin; little-plugger searches all
installed gems for files matching the globspec.

## EXAMPLE FLAVOR STRUCTURE

This example defines a flavor named `Example`. It can only generate
cookbooks, as its code_generator cookbook contains no other recipes.

A functional copy of this plugin is available on rubygems as
`chef-gen-flavor-example`.

The directory structure of a plugin looks like this:

    chef-gen-flavor-example
    ├── code_generator
    │   ├── files
    │   │   └── default
    │   ├── metadata.rb
    │   ├── recipes
    │   │   └── cookbook.rb
    │   └── templates
    │       └── default
    └── lib
        └── chef_gen
            └── flavor
                └── example.rb

It is important that the name of the directory in which your generator
cookbook lives matches the name in metadata.rb.  ChefDK uses the last
element of the path as the cookbook name, so if you put your cookbook
in a folder called 'cookbook' but your metadata.rb declares the name
as 'code_generator', ChefDK won't be able to find your recipe.

## ALTERNATE code_generator PATHS

By default, the code_generator cookbook is assumed to live in a directory
named `code_generator` four levels higher than the path of the file
definining the plugin.

To specify that the code_generator cookbook lives elsewhere, define a class
method named `code_generator_path` which takes one argument (the path to the
plugin class) and returns the path to the code_generator cookbook. If the
`Example` plugin wanted to place the code_generator cookbook in a directory
named `template` instead of `code_generator`, it would define an instance
method like this:

    module ChefGen
      module Flavor
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

For compatibility with all platforms supported by ChefDK, plugins should use
the methods in the `File` class to construct relative paths rather than
assuming what the path separator should be.

## GENERATOR PATH COPY

When #path is called, chef-gen-flavors makes a copy of the selected
generator cookbook to a temporary path, which is what gets returned
and used by ChefDK.  This path is cleaned up at exit unless the environment
variable CHEFGEN_NOCLEANTMP is set.

## ADDING CONTENT TO THE GENERATOR COPY

After the generator is copied to a temporary path, the #add_content
instance method is called (if it exists) on the flavor class.  It is
passed one arg: the path to the temporary copy.

This allows flavors to create content dynamically by writing files
to the proper directly.  It is exploited by the flavor base class
described below.

## FLAVOR BASE CLASS

A framework for easily building flavors is distributed as a separate gem called [chef-gen-flavor-base](https://github.com/jf647/chef-gen-flavor-base)

## FEATURE TESTING FLAVORS

chef-gen-flavors provides a number of useful step definitions for Aruba
(a CLI driver for Cucumber) to make it easier to test flavors.  To
access these definitions, add the following line to your
`features/support/env.rb` file:

    require 'chef_gen/flavors/cucumber'

For an example of how to use these steps in your features, refer to the
reference implementation of a flavor:
[chef-gen-flavor-example](https://github.com/jf647/chef-gen-flavor-example).

Documentation for the steps themselves is in the file `ARUBA_STEPS.md`

## AUTHOR

[James FitzGibbon](https://github.com/jf647)

## LICENSE

Copyright 2015 Nordstrom, Inc.

Copyright 2015 James FitzGibbon

Licensed under the Apache License, Version 2.0 (the "License"); you may not
use this file except in compliance with the License. You may obtain a copy
of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
License for the specific language governing permissions and limitations
under the License.
