role :app, %w{travis@zealot.kelsin.net}
role :web, %w{travis@zealot.kelsin.net}
role :db,  %w{travis@zealot.kelsin.net}

set :deploy_to, '/home/travis/byfirebepurged'
set :default_env, { 'DATABASE_URL' => ENV['CAP_DATABASE_URL'] }
set :branch, 'master'
