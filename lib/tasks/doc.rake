require 'rdoc/task'
require 'rails/tasks'

Rake::Task["doc:app"].clear

namespace :doc do
  RDoc::Task.new('app') do |rdoc|
    rdoc.rdoc_dir = 'doc'
    rdoc.title    = 'By Fire Be Purged'
    rdoc.main     = 'README.rdoc' # define README_FOR_APP as index
    rdoc.generator = 'hanna'

    rdoc.options << '--charset' << 'utf-8'

    rdoc.rdoc_files.include('app/**/*.rb')
    rdoc.rdoc_files.include('config/**/*.rb')
    rdoc.rdoc_files.include('lib/**/*.rb')
    rdoc.rdoc_files.include('README.rdoc')
  end
end
