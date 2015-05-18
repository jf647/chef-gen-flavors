# Aruba step definitions for feature testing flavors

chef-gen-flavors provides a number of useful Aruba step definitions to help
test your flavors.

Aruba is a CLI driver for Cucumber. It works off of the same feature files
you may be used to using in Capybara for web app testing (though the steps
are perforce quite different).

To access these definitions,
add the following line to your `features/support/env.rb` file:

    require 'chef_gen/flavors/cucumber'

For an example of how to use these steps in your features, refer to the
reference implementation of a flavor:
[chef-gen-flavor-example](https://github.com/Nordstrom/chef-gen-flavor-example).

## knife

    Given a knife.rb that uses chef-gen-flavors

Creates a simple knife.rb that requires chef-gen-flavors:

    require 'chef_gen/flavors'
    chefdk.generator_cookbook = ChefGen::Flavors.path

## chefdk

    When I generate a cookbook named "foo"
    When I generate a cookbook named "foo" with the "-a bar=baz" option

Generates a cookbook using `chef generate cookbook`, optionally with
additional command line args. To ensure that you do not get a prompt, you
should first select your flavor using environment variables:

    And I set the environment variables to:
      | variable       | value    |
      |----------------|----------|
      | CHEFGEN_FLAVOR | myflavor |

## bundle

    When I bundle gems

Runs 'bundle' after unsetting the bundler environment variables (so that you
use the bundle that belongs to your generated artifact, not the bundle of
your flavor gem).

## rake

    When I run a style test
    When I run a unit test

Runs 'bundle exec rake style' or 'bundle exec rake spec'

    When I list the rake tasks

Runs 'bundle exec rake -T'

## kitchen

    When I list the kitchen suites

Runs 'bundle exec kitchen list'

## regex

    Then the output should match each of:
      | ^regex1 |
      | regex2$ |

Not really a chef-gen-flavors step, but provides a simple way to check
multiple regexes against the output.
