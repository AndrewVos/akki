# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "akki/version"

Gem::Specification.new do |s|
  s.name        = "akki"
  s.version     = Akki::VERSION
  s.authors     = ["Andrew Vos"]
  s.email       = ["andrew.vos@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{}
  s.description = %q{}

  s.rubyforge_project = "akki"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.add_dependency 'sinatra'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'capybara'
  s.require_paths = ["lib"]
end
