Gem::Specification.new do |s|
  s.name = %q{artesia}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Artem Kalinchuk"]
  s.date = %q{2011-09-19}
  s.description = %q{The Artesia Gem provides integration access to the Artesia DAM.}
  s.email = %q{artem9@gmail.com}
  s.files = ["lib/artesia.rb", "artesia.gemspec", "README.rdoc", "lib/classes/api.rb", "lib/classes/connection.rb"]
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Quickbase"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{artesia}
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{Artesia Ruby Gem}
  s.add_dependency(%q<mechanize>, [">= 0"])
end
