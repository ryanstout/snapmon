require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test


begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "snapmon"
    gemspec.summary = "Makes monitoring your app easy"
    gemspec.description = "Provides an interface to configure monitoring via snapmon.com from a config file."
    gemspec.email = "help@snapmon.com"
    gemspec.homepage = "http://github.com/ryanstout/snapmon"
    gemspec.authors = ["Ryan Stout2"]
  end
	Jeweler::GemcutterTasks.new

rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

desc 'Test the snapmon plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the snapmon plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'SnapMon'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
