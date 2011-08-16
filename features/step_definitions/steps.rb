Before do
  Akki::Application.set :views, "features/fixtures/views"
end

Given /^I have the article file "([^"]*)"$/ do |article_file, article_contents|
  articles_path = File.join(File.dirname(__FILE__), '..', '..', 'articles')
  FileUtils.mkdir_p(articles_path)
  File.open(File.join(articles_path, article_file), 'w') do |file|
    file.write(article_contents)
  end
end

Given /^I have the page "example-page"$/ do
end

Given /^I visit "([^"]*)"$/ do |url|
  visit "/#{url}"
end

Then /^I should see:$/ do |content|
  page.source.should include content
end
