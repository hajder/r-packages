module Cran
  CRAN_URI = 'http://cran.r-project.org/src/contrib/'
  
  def self.fetch_index
    packages = self.cache_path('PACKAGES')
    if File.exists?(packages) && File.mtime(packages) < 12.hours.ago
      File.unlink(packages)
    end
    self.cache_or_download('PACKAGES')
  end
  
  def self.fetch_package_details(package_info)
    raise ArgumentError, 'incomplete packet information' if package_info['Package'].blank? || package_info['Version'].blank?
    
    file = self.cache_or_download(package_info['Package'], package_info['Version'], 'tar.gz')
    tar = Gem::Package::TarReader.new(Zlib::GzipReader.open(file))
    dcf = tar.seek(package_info['Package'] + '/DESCRIPTION') do |desc|
      Dcf.parse desc.read
    end
    
    cran_data = dcf[0] rescue {}
    cran_data.transform_keys!{ |key| key.to_s.downcase.to_sym }
    cran_data.slice( \
      :version, :title, :description, :dependencies, :depends, :suggestions,
      :suggests, :license, :'date/publication', :maintainer, :author
    )
  rescue OpenURI::HTTPError
    {}
  end
  
  def self.cache_or_download(package, version = nil, extension = nil)
    base_name = [package, version].compact.join('_')
    filename = [base_name, extension].compact.join('.')
    
    unless File.exists?(self.cache_path(filename))
      cache = File.new(self.cache_path(filename), 'wb')
      cache.write(open(CRAN_URI + filename).read)
      cache.close
    end
    
    File.open self.cache_path(filename)
  end
  
  def self.cache_path(filename)
    Rails.root.join('tmp', 'packages', filename)
  end
end