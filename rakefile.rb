require 'bundler/gem_tasks'

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.test_files = FileList['spec/lib/**/*_spec.rb']
  t.verbose = false
  t.warning = !!ENV['TEST_WARNINGS']
end

namespace :yard do
  desc "Run local YARD documentation server"
  task :server do
    `rm -rf ./.yardoc`
    Thread.new do
      sleep 2
      `open http://localhost:8808`
    end
    `yard server -r`
  end
end

Rake::Task[:test].enhance do
  unless ENV['TEST_WARNINGS']
    puts "Ruby warnings disabled, set TEST_WARNINGS environment variable to enable."
  end
end

task default: :test
