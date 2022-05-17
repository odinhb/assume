# frozen_string_literal: true

require "bundler/gem_tasks"

task :spec do
  sh "bundle exec rspec spec/assume_spec.rb"
  sh "bundle exec rspec spec/core_ext_spec.rb"
  sh "bundle exec rspec spec/refine_spec.rb"
end
task default: :spec
task test: :spec

task :console do
  exec 'bundle exec bin/console'
end
