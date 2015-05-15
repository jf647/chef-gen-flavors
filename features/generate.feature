Feature: chef generate

  Verifies that 'chef generate cookbook' works when the generator
  path is dynamically chosen by chef-gen-flavors

  Scenario: generate cookbook
    Given a knife.rb that uses chef-gen-flavors
    And I set the environment variables to:
      | variable       | value                            |
      |----------------|----------------------------------|
      | CHEFGEN_FLAVOR | bar                              |
      | RUBYLIB        | ../../spec/support/fixtures/lib |
    When I generate a cookbook named 'foo'
    Then the exit status should be 0
    And the output should match /using ChefGen flavor 'bar'/
    And the output should match /Recipe: code_generator_2::cookbook/
    And the output should match /- create new file README.md/
