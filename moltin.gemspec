# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'moltin/version'

Gem::Specification.new do |spec|
  spec.name          = 'moltin'
  spec.version       = Moltin::VERSION
  spec.authors       = ['T-Dnzt']
  spec.email         = ['thi.denizet@gmail.com']

  spec.summary       = 'Moltin Ruby SDK'
  spec.description   = 'Unified APIs for inventory, carts, the checkout process,
                        payments and more, so you can focus on creating seamless
                        customer experiences at any scale.'
  spec.homepage      = 'https://www.moltin.com/'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.rdoc_options = ['--charset=UTF-8']
  spec.extra_rdoc_files = %w[README.md]

  spec.add_dependency 'faraday', '~> 0.11'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.47.1'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.12'
  spec.add_development_dependency 'webmock', '~> 2.1'
  spec.add_development_dependency 'vcr', '~> 3.0'
end
