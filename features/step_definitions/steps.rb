Before do
  @articles_path = File.join(File.dirname(__FILE__), '..', '..', 'articles')
  @views_path = File.join(File.dirname(__FILE__), '..', '..', 'views')
  @pages_path = File.join(@views_path, 'pages')
  FileUtils.mkdir_p(@articles_path)
  FileUtils.mkdir_p(@views_path)
  FileUtils.mkdir_p(@pages_path)
end

After do
  FileUtils.rm_rf @articles_path
  FileUtils.rm_rf @views_path
end

Given /^I have the article file "([^"]*)"$/ do |article_file, article_contents|
  File.open(File.join(@articles_path, article_file), 'w') do |file|
    file.write(article_contents)
  end
end

Given /^I have the view "([^"]*)" with the contents$/ do |view, contents|
  File.open(File.join(@views_path, view), 'w') do |file|
    file.write(contents)
  end
end

Given /^I have the page "([^"]*)":$/ do |page, contents|
  File.open(File.join(@pages_path, page), 'w') do |file|
    file.write(contents)
  end
  page_name = File.basename(page, File.extname(page))
  Akki::Application.set :pages, [page_name.to_sym]
end

Given /^I visit "([^"]*)"$/ do |url|
  visit url
end

Given /^the application setting "([^"]*)" with the value "([^"]*)"$/ do |name, value|
  Akki::Application.set name, value
end

Then /^I should see:$/ do |content|
  page.source.chomp.should == content
end

Then /^I should see a (\d+) html status code$/ do |status_code|
  page.status_code.should == status_code.to_i
end
