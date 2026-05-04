max_threads_count = ENV.fetch("RAILS_MAX_THREADS", 5)

threads 0, max_threads_count
workers 0
environment ENV.fetch("RAILS_ENV", "development")
bind "tcp://#{ENV.fetch("HOST", "0.0.0.0")}:#{ENV.fetch("PORT", 8585)}"
silence_single_worker_warning
