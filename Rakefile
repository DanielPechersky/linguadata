# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "standard/rake"

task :typecheck do
  sh "steep check"
end

task :mutant do
  sh "mutant run --require linguadata --integration rspec -- 'Linguadata*'"
end

task default: %i[typecheck spec mutant]
