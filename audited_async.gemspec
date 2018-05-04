
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'audited_async/version'

Gem::Specification.new do |spec|
  spec.name          = 'audited_async'
  spec.version       = AuditedAsync::VERSION
  spec.authors       = ['Leonardo Falk']
  spec.email         = %w[leonardo.falk@hotmail.com]

  spec.summary       = 'Execute audited asynchronously with ActiveJob.'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/leonardofalk/audited_async'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]

  spec.add_dependency 'audited', '>= 4.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'wonder-ruby-style'
  spec.add_development_dependency 'rails'
  spec.add_development_dependency 'codeclimate-test-reporter'
end
