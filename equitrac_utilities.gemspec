
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "equitrac_utilities/version"

Gem::Specification.new do |spec|
  spec.name          = "equitrac_utilities"
  spec.version       = EquitracUtilities::Version::VERSION
  spec.authors       = ["Bill Tihen", "Lee Weisbecker", "Elliott Hébert"]
  spec.email         = ["btihen@gmail.com", "leeweisbecker@gmail.com"]

  spec.summary       = %q{Simple ruby wrapper for equitrac user management}
  spec.description   = %q{uses ssh to connect to an Equitrac server and send user commands}
  spec.homepage      = "https://github.com/LAS-IT/equitrac_utilities"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  # spec.require_paths = ["lib"]
  spec.files = Dir['lib/**/*.rb']

  spec.add_dependency "net-ssh", "~> 5.2"

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.9"
end
