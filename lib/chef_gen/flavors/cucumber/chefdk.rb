Given(/I generate a cookbook named "(.+)"(?: with the "(.+)" options?)?/) do |cbname, opts|
  run_simple "chef generate cookbook #{cbname} #{opts}"
end
