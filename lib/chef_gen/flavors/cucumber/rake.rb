Given(/^I run a style test$/) do
  unset_bundler_env_vars
  run_simple 'bundle exec rake style', true, 10
end

Given(/^I run a unit test$/) do
  unset_bundler_env_vars
  run_simple 'bundle exec rake spec', true, 10
end

Given(/^I list the rake tasks$/) do
  unset_bundler_env_vars
  run_simple 'bundle exec rake -T'
end
