Given(/^I list the kitchen suites$/) do
  unset_bundler_env_vars
  run_simple 'bundle exec kitchen list'
end
