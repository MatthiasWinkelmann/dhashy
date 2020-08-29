
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dhashy/version"

Gem::Specification.new do |spec|
  spec.name          = "dhashy"
  spec.version       = Dhashy::VERSION
  spec.authors       = ["Matthias Winkelmann"]
  spec.email         = ["m@matthi.coffee"]

  spec.summary       = %q{Perceptive Image Hashing and Deduplication.}
  spec.description   = %q{A transformation-robust image comparison usign the difference hash (dhash) algorithm.}
  spec.homepage    = "https://github.com/MatthiasWinkelmann/dhashy"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec)/})
  end

  spec.require_paths = ["lib"]
  spec.add_dependency "mini_magick", "~> 4.1"
  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.1"
end
