workers Integer(ENV['PROCESSES'] || 4)
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  Mongoid.load!(Rails.root.join('config', 'mongoid.yml'))
end
