require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'cucumber/rake/task'

task :default => [:spec, :cucumber]

RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = ["--color"]
end
Cucumber::Rake::Task.new(:cucumber)
