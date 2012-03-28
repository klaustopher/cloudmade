require "bundler/gem_tasks"

require 'rake'
require 'rake/testtask'

task :test => [:test_units]

desc "Run unit tests"
Rake::TestTask.new("test_units") { |t|
  t.pattern = 'test/test_*.rb'
  t.verbose = true
  t.warning = true
}
