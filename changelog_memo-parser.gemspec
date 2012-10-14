# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'changelog_memo-parser/version'

Gem::Specification.new do |gem|
  gem.name          = "changelog_memo-parser"
  gem.version       = ChangelogMemo::Parser::VERSION
  gem.authors       = ["koyachi"]
  gem.email         = ["rtk2106@gmail.com"]
  gem.description   = %q{Parse changelog memo text.}
  gem.summary       = %q{Parse changelog memo text.}
  gem.homepage      = "https://github.com/koyachi/ruby-changelog_memo-parser"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
