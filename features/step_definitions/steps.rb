Given /^I have the article file "([^"]*)"$/ do |article_file, article_contents|
  articles_path = File.join(File.dirname(__FILE__), '..', '..', 'articles')
  FileUtils.mkdir_p(articles_path)
  File.open(File.join(articles_path, article_file), 'w') do |file|
    file.write(article_contents)
  end
end

Given /^the layout template:$/ do |contents|
  views_path = File.join(File.dirname(__FILE__), '..', '..', 'views')
  FileUtils.mkdir_p(views_path)
  File.open(File.join(views_path, 'layout.haml'), 'w') do |file|
    file.write(contents)
  end
end

Given /^the article template:$/ do |contents|
  views_path = File.join(File.dirname(__FILE__), '..', '..', 'views')
  FileUtils.mkdir_p(views_path)
  File.open(File.join(views_path, 'article.haml'), 'w') do |file|
    file.write(contents)
  end
end

Given /^I visit "([^"]*)"$/ do |url|
  visit "/#{url}"
end

Then /^I should see:$/ do |content|
  page.source.should == content
end
