class PackageVersion < ActiveRecord::Base
  belongs_to :package
  
  alias_attribute :depends, :dependencies
  alias_attribute :suggests, :suggestions
  alias_attribute :'date/publication', :publication
  alias_attribute :date, :publication
  
  after_save :set_package_to_latest_version
  
  def self.find_or_create_with_cran(package_info)
    found = self.find_or_initialize_by(version: package_info['Version'])
    
    if found.new_record?
      # found.package = Package.find_by!(name: package_info['Package']) if found.package.nil?
      found.attributes = Cran.fetch_package_details(package_info)
      
      begin
        found.save!
      rescue
        found.author = found.author.encode('ASCII-8BIT', 'UTF-8', invalid: :replace)
        found.maintainer = found.maintainer.encode('ASCII-8BIT', 'UTF-8', invalid: :replace)
        found.save
      end
    end
    
    found
  end
  
  def set_package_to_latest_version
    if package.latest_version.to_s < self.version
      package.latest_version = self.version
      package.save
    end
  end
end
