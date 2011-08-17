Before do
  @articles_path = File.join(File.dirname(__FILE__), '..', '..', 'articles')
  FileUtils.mkdir_p(@articles_path)
  Akki::Application.set :views, "features/fixtures/views"
end

After do
  FileUtils.rm_rf @articles_path if File.exist?(@articles_path)
end

Given /^I have the article file "([^"]*)"$/ do |article_file, article_contents|
  File.open(File.join(@articles_path, article_file), 'w') do |file|
    file.write(article_contents)
  end
end

Given /^I have the page "example-page"$/ do
end

Given /^I visit "([^"]*)"$/ do |url|
  visit url
end

Then /^I should see:$/ do |content|
  page.source.should include content
end

Given /^I have an archive template that shows the article title$/ do
end
