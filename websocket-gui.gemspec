# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'websocket-gui/version'

Gem::Specification.new do |spec|
  spec.name          = "websocket-gui"
  spec.version       = WebsocketGui::VERSION
  spec.authors       = ["Jason Pollentier"]
  spec.email         = ["pollentj@gmail.com"]
  spec.description   = %q{Use Sinatra, Websockets, and EventMachine to create
  an event-based GUI for Ruby projects that would otherwise be stuck in the console.
}
  spec.summary       = %q{Use the browser as a GUI for local Ruby apps.}
  spec.homepage      = ""
  spec.license       = "MIT"
  spec.homepage		 = "https://github.com/grossvogel/websocket-gui"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '~> 2.0'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_runtime_dependency 'em-websocket', '~> 0.5.0'
  spec.add_runtime_dependency 'sinatra', '~> 1.4.3'
  spec.add_runtime_dependency 'thin', '~> 1.5.1'
  spec.add_runtime_dependency 'launchy', '~> 2.3.0'
  spec.add_runtime_dependency 'json', '>= 1.7.7'
end
