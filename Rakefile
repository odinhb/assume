# frozen_string_literal: true

require "bundler/gem_tasks"

task :spec do
  sh "rspec spec/assume_spec.rb"
  sh "rspec spec/core_ext_spec.rb"
  sh "rspec spec/refine_spec.rb"
end
task default: :spec

task :console do
  exec 'bin/console'
end
