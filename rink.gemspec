
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rink/version"

Gem::Specification.new do |spec|
  spec.name          = "rink"
  spec.version       = Rink::VERSION
  spec.authors       = ["YusukeIwaki"]
  spec.email         = ["iwaki@i3-systems.com"]

  spec.summary       = %q{Build beautiful command-line apps with Ruby}
  spec.description   = %q{Rink is a Ruby library for building beautiful, interactive command-line applications with a simple, declarative syntax. Inspired by React and Ink, it brings component-based architecture and modern UI patterns to the terminal.}
  spec.homepage      = "https://github.com/YusukeIwaki/rink"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/YusukeIwaki/rink"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|examples|dev_examples)/}) || f.include?('CLAUDE.md') }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
