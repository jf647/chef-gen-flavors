Given(/the output should match each of:/) do |regexes|
  regexes.raw.map { |row| assert_matching_output(row[0], all_output) }
end
