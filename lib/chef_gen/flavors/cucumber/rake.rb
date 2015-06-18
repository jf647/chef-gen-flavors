Given(/^I run a style test$/) do
  run_simple 'bundle exec rake style', true, @aruba_timeout_seconds
end

Given(/^I run a unit test$/) do
  run_simple 'bundle exec rake spec', true, @aruba_timeout_seconds
end

Given(/^I list the rake tasks$/) do
  run_simple 'bundle exec rake -T'
end
