# frozen_string_literal: true

require_relative "lib/linguadata/version"

Gem::Specification.new do |spec|
  spec.name = "linguadata"
  spec.version = Linguadata::VERSION
  spec.authors = ["Daniel Pechersky"]
  spec.email = ["danny.pechersky@gmail.com"]

  spec.summary = "Result and Option types in Ruby, inspired by Rust"
  spec.description = "Bringing Rust's Result and Option types to Ruby, using the Data class introduced in Ruby 3.2"
  spec.homepage = "https://github.com/DanielPechersky/linguadata"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
