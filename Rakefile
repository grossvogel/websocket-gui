require "bundler/gem_tasks"
require 'rubygems'
require 'rake'
require 'date'

#################################################################################
#
#	Some utilities to find out info about the package
#
#################################################################################

def name
	@name ||= Dir['*.gemspec'].first.split('.').first
end

def version
	line = File.read("lib/#{name}/version.rb")[/^\s*VERSION\s*=\s*.*/]
	line.match(/.*VERSION\s*=\s*['"](.*)['"]/)[1]
end

def gemspec_file 
	"#{name}.gemspec"
end

def gem_file
	"pkg/#{name}-#{version}.gem"
end

#################################################################################
#
#	Tasks
#
#################################################################################

desc "Run the tests"
task :default => :spec

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
 
desc "Build gem locally"
task :build => :validate do
  system "gem build #{name}.gemspec"
  FileUtils.mkdir_p "pkg"
  FileUtils.mv "#{name}-#{version}.gem", gem_file 
end

desc "Publish the gem to rubygems.org"
task :publish => :build do
  system "gem push #{gem_file}"
end
 
desc "Install gem locally"
task :install => :build do
  system "gem install #{gem_file}"
end

desc "Validate #{gemspec_file}"
task :validate do
  libfiles = Dir['lib/*'] - ["lib/#{name}.rb", "lib/#{name}"]
  unless libfiles.empty?
    puts "Directory `lib` should only contain a `#{name}.rb` file and `#{name}` dir."
    exit!
  end
  unless Dir['VERSION*'].empty?
    puts "A `VERSION` file at root level violates Gem best practices."
    exit!
  end
end
