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

[chef-gen-flavor-base](https://github.com/jf647/chef-gen-flavor-base) is
a base class that makes it easy to compose a flavor from reusable
snippets of functionality, and using it is highly recommended.  Using
chef-gen-flavors on its own is only suitable if you already have a
template which is a copy of the skeleton provided by ChefDK.

At present this is focused primarily on providing templates for
generation of cookbooks, as this is where most organization-specific
customization takes place. Support for the other artifacts that ChefDK
can generate may work, but is not the focus of early releases.

### BREAKING API CHANGES

v0.9.0 of chef-gen-flavors is very different from chef-gen-flavors
v0.8.x.  Flavors will need to be re-worked, and the base flavor class
and associated snippets have been extracted to their own gem.

v0.8.6 contained a warning about this change; if you are not ready to
upgrade your flavor you can pin to this version to keep the old API.

## INSTALLATION

You should not install this gem directly; it will be installed as a
dependency of a flavor gem.  If you are developing a flavor, declare
this gem a dependency of your gem in your gemspec file:

```ruby
Gem::Specification.new do |s|
  s.name = 'chef-gen-flavor-awesome'
  s.add_runtime_dependency('chef-gen-flavors', ['~> 0.9'])
  ...
end
```

Then make bundler read your gemspec:

```ruby
source 'https://rubygems.org/'
gemspec
```

And use bundler to install your dependencies:

```bash
$ bundle
```

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

## FLAVORS

This gem uses [little-plugger](https://rubygems.org/gems/little-plugger) to
make adding template flavors easy. Each flavor is defined by a plugin named
using [little-pluggers's
rules](https://github.com/TwP/little-plugger/blob/little-plugger-1.1.2/lib/little-plugger.rb#L13-25).

The plugin must define a class inside the naming hierarchy
`ChefGen::Flavor::`. The class name should be the filename converted to
CamelCase (e.g. `foo_bar.rb` = `FooBar`)

The name of the class must not be in all caps, as little-plugger ignores
these (assuming that they are constants).

You do not have to `require` your plugin; little-plugger searches all
installed gems for files matching the globspec.

Flavor classes must also:

* define a NAME constant which is the name of the flavor in lowercase
* provide an `#add_content` method, which is responsible for copying content to the temporary directory created by chef-gen-flavors

## EXAMPLE FLAVOR STRUCTURE

This example defines a flavor named `Example`. It can only generate
cookbooks, as its code_generator cookbook contains no other recipes.

A functional copy of this plugin is available on rubygems as
`chef-gen-flavor-example`.

The directory structure of a plugin looks like this:

    chef-gen-flavor-example
    ├── lib
    │   └── chef_gen
    │       └── flavor
    │           └── example.rb
    └── shared
        └── flavor
            └── example
                ├── metadata.rb
                └── recipes
                    └── cookbook.rb

It is important that the name of the flavor matches the name in
metadata.rb.  ChefDK uses the last element of the path as the cookbook
name, so if you put your cookbook in a folder called 'cookbook' but your
metadata.rb declares the name as 'example', ChefDK won't be able
to find your recipe.

## COPYING CONTENT

When #path is called, chef-gen-flavors creates a temporary directory,
which is passes as an argument to the flavor class' constructor:

```ruby
class ChefGen
  module Flavor
    class Awesome
      NAME = 'awesome'

      def initialize(temp_path:)
        @temp_path = temp_path
      end
    end
  end
end
```

The flavor is responsible for copying everything required to run
generation to that path by defining a `#add_content` method.  For a
simple flavor, that might be just a recursive copy:

```ruby
class ChefGen
  module Flavor
    class Awesome
      ...
      def add_content
        FileUtils.cp_r(
          File.expand_path(
            File.join(
              File.dirname(__FILE__),
              '..', '..', '..', 'shared', 'flavor', NAME
            )
          ) + '/.',
          @temp_path
        )
      end
    end
  end
end
```

Once the add_content method has been called, it is returned as the
value of `chefdk.generator_cookbook`, and generation proceeds as if
you had given `chef generate` and alternate path by passing -g.

This path is cleaned up at exit unless the environment
variable `CHEFGEN_NOCLEANTMP` is set.

When using ChefGen::FlavorBase, there are helper functions to compose
the temporary directory from files that come from a mix of flavors and
reusable components.

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
