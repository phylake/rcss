# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "ruby-css"
  s.version     = `git tag`.split("\n").last
  s.authors     = ["Brandon Cook"]
  s.email       = ["phylake@gmail.com"]
  s.homepage    = "https://github.com/phylake/ruby-css"
  s.summary     = %q{Write a gem summary}
  s.description = %q{Write a gem description}

  # s.rubyforge_project = "ruby_css"

  s.files         = `git ls-files`.split("\n")
  # s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  # s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
