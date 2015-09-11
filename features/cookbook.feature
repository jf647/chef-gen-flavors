Feature: chef generate

  Verifies that 'chef generate cookbook' works when the generator
  path is dynamically chosen by chef-gen-flavors

  Scenario: generate cookbook that does nothing
    Given a knife.rb that uses chef-gen-flavors
    And I set the environment variables to:
      | variable       | value                            |
      |----------------|----------------------------------|
      | CHEFGEN_FLAVOR | foo                              |
      | RUBYLIB        | ../../spec/support/fixtures/lib  |
    When I generate a cookbook named "foo"
    Then the exit status should be 0
    And the output should match /using ChefGen flavor 'foo'/

  Scenario: generate cookbook that does something
    Given a knife.rb that uses chef-gen-flavors
    And I set the environment variables to:
      | variable       | value                            |
      |----------------|----------------------------------|
      | CHEFGEN_FLAVOR | bar                              |
      | RUBYLIB        | ../../spec/support/fixtures/lib  |
    When I generate a cookbook named "foo"
    Then the exit status should be 0
    And the output should match /using ChefGen flavor 'bar'/
    And the output should match /Recipe: bar::cookbook/
    And the output should match /- create new file.+README.md/

  Scenario: generate cookbook that provides no content
    Given a knife.rb that uses chef-gen-flavors
    And I set the environment variables to:
      | variable       | value                            |
      |----------------|----------------------------------|
      | CHEFGEN_FLAVOR | baz                              |
      | RUBYLIB        | ../../spec/support/fixtures/lib  |
    When I run `chef generate cookbook foo`
    Then the exit status should not be 0
    And the output should match /ERROR: Could not find cookbook\(s\) to satisfy run list \["recipe\[baz::cookbook\]"\]/

  Scenario: generate cookbook using built-in ChefDK flavor
    Given a knife.rb that uses chef-gen-flavors
    And I set the environment variables to:
      | variable       | value |
      |----------------|-------|
      | CHEFDK_FLAVOR  | 1     |
    When I run `chef generate cookbook foo`
    Then the exit status should be 0
    And the file "foo/README.md" should match /TODO: Enter the cookbook description here./

  Scenario: choose builtin flavor using env var
    Given a knife.rb that uses chef-gen-flavors
    And I set the environment variables to:
      | variable       | value                            |
      |----------------|----------------------------------|
      | CHEFDK_FLAVOR  | 1                                |
      | CHEFGEN_FLAVOR | builtin                          |
      | RUBYLIB        | ../../spec/support/fixtures/lib  |
    When I run `chef generate cookbook foo`
    Then the exit status should be 0
    And the file "foo/README.md" should match /TODO: Enter the cookbook description here./
