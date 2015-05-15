Given(/I generate a cookbook named '(.+)'/) do |cbname|
  run_simple "chef generate cookbook #{cbname}"
end
