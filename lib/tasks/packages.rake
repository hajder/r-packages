require 'open-uri'
require 'dcf'
require 'rubygems/package'

namespace :packages do
  desc "fetch and update r packages from cran"
  task :update => :environment do
    index = Cran.fetch_index
    
    print 'Parsing list...'
    packages = Dcf.parse index.read
    puts ' DONE'
    
    puts 'Fetching packages information...'
    
    packages.each do |package_info|
      puts "#{package_info['Package']}_#{package_info['Version']}"
      package = Package.find_or_create_by(name: package_info['Package'])
      version = package.versions.find_or_create_with_cran(package_info)
    end
  end
  
end
