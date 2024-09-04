# Puma Configuration File

# Set the environment for Puma (e.g., production, development, etc.)
environment ENV.fetch("RAILS_ENV") { "development" }

# Number of workers to spin up
# Workers are forked processes, so you may want more in production
workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# Number of threads to use per worker
# Adjust based on your application’s needs and server capacity
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

# Puma listens on both Unix and TCP sockets
# By default, Puma will bind to a TCP port
bind "tcp://0.0.0.0:3000"

# Set a PID file for the server process
pidfile "tmp/pids/puma.pid"

# Set a path for Puma’s state
state_path "tmp/pids/puma.state"

# Enable the preload_app feature
# Helps with faster worker boot times by loading the application before forking
preload_app!

# Allows Puma to handle graceful restarts
# This will allow Puma to restart without dropping connections
on_restart do
  puts 'Refreshing Gemfile'
  ENV['BUNDLE_GEMFILE'] = File.expand_path('../Gemfile', __FILE__)
end

# Set a worker timeout
# Defines the timeout for worker processes, typically used in production
worker_timeout 60

# Optional: Configure Puma to run in a daemonized mode (usually not for development)
# daemonize

# Optional: Configure log files for Puma (you might want to configure this differently for production)
stdout_redirect 'log/puma.stdout.log', 'log/puma.stderr.log', true
