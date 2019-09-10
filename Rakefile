# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

if ENV['IN_DOCKER']
  task default: :rspec
else
  task default: :ci
end

Rails.application.load_tasks

require 'solr_wrapper/rake_task' unless Rails.env.production?

task :ci do
  with_server 'test' do
    Rake::Task['spec'].invoke
    Rake::Task['spec:javascript'].invoke
  end
end

task :rspec do
  Rake::Task['spec'].invoke
  Rake::Task['spec:javascript'].invoke
end
