Gem::Specification.new do |s|
  s.name = %q{assertthat-bdd}
  s.version = "1.4.0"
  s.date = %q{2020-05-08}
  s.summary = %q{AssertThat bdd integration for Ruby}
  s.authors     = ["Glib Briia"]
  s.email       = 'glib@assertthat.com'
  s.homepage    = 'https://rubygems.org/gems/assertthat-bdd'
  s.licenses    = ['MIT']
  s.executables   = ["assertthat-bdd-features", "assertthat-bdd-report"]  
  s.add_runtime_dependency 'rest-client', '~> 2.0', '>= 2.0.2'
  s.add_runtime_dependency 'rubyzip', '~> 1.0', '>= 1.0.0'
  s.files = [
    "lib/assertthat-bdd.rb"
  ]
  s.require_paths = ["lib"]
end
