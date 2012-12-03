worker_processes 4
working_directory "/home/soxtest/app/current"

#listen '/tmp/unicorn_captest.sock'
listen 10050, :tcp_nopush => true

timeout 1200

preload_app true

pid "/home/soxtest/app/shared/pids/unicorn.pid"
stderr_path "/home/soxtest/app/shared/log/unicorn.stderr.log"
stdout_path "/home/soxtest/app/shared/log/unicorn.stdout.log"

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!

  old_pid = "#{ server.config[:pid] }.oldbin"
  unless old_pid == server.pid
    begin
      # SIGTTOU だと worker_processes が多いときおかしい気がする
      Process.kill :QUIT, File.read(old_pid).to_i
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end


