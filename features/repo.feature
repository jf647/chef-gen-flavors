Feature: chef generate repo

  'chef generate repo' is used to generate a chef repo

  Scenario: generate repo using flavor without a repo recipe
    Given a knife.rb that uses chef-gen-flavors
    And I set the environment variables to:
      | variable       | value                            |
      |----------------|----------------------------------|
      | CHEFGEN_FLAVOR | foo                              |
      | RUBYLIB        | ../../spec/support/fixtures/lib  |
    When I run `chef generate repo foo`
    Then the exit status should not be 0
    And the output should match /could not find recipe repo for cookbook foo/

  Scenario: generate repo using builtin flavor
    Given a knife.rb that uses chef-gen-flavors
    And I set the environment variables to:
      | variable       | value                            |
      |----------------|----------------------------------|
      | CHEFDK_FLAVOR  | 1                                |
      | CHEFGEN_FLAVOR | builtin                          |
      | RUBYLIB        | ../../spec/support/fixtures/lib  |
    When I run `chef generate repo foo`
    Then the exit status should be 0
    And a file named "foo/data_bags/example/example_item.json" should exist
    And the file "foo/README.md" should match /Every Chef installation needs a Chef Repository./
