# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'byfirebepurged'
set :repo_url, 'git@github.com:kelsin/byfirebepurged.git'

set :ssh_options, keys: ["config/deploy_id_rsa"], forward_agent: true if File.exist?("config/deploy_id_rsa")
set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle')
set :chruby_ruby, '2.1.10'
