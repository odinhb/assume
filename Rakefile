# frozen_string_literal: true

require "bundler/gem_tasks"
# require "rspec/core/rake_task"

# RSpec::Core::RakeTask.new(:spec)

task :spec do
  puts `rspec spec/assume_spec.rb`
  puts `rspec spec/core_ext_spec.rb`
  puts `rspec spec/refine_spec.rb`
end
task default: :spec

task :console do
  exec 'bin/console'
end
