require Rails.root.join 'lib', 'cran'
require 'test_helper'
require 'fileutils'

module Cran
  CRAN_URI = '/tmp/cran/'
  
  def self.cache_path(filename)
    '/tmp/packages/' + filename
  end
end

class CranTest < ActiveSupport::TestCase
  setup do
    FileUtils.mkdir '/tmp/packages' rescue nil
    FileUtils.mkdir '/tmp/cran' rescue nil
  end
  
  test "cache_or_download should properly assemble simple file name" do
    FileUtils.touch '/tmp/packages/PACKAGES'
    file = Cran.cache_or_download('PACKAGES')
    assert_equal file.path, '/tmp/packages/PACKAGES'
  end
  
  test "cache_or_download should properly assemble two part file name" do
    FileUtils.touch '/tmp/packages/test_0.0.1'
    file = Cran.cache_or_download('test', '0.0.1')
    assert_equal file.path, '/tmp/packages/test_0.0.1'
  end
  
  test "cache_or_download should properly assemble two part file name with extension" do
    FileUtils.touch '/tmp/packages/test_0.0.1.tar.gz'
    file = Cran.cache_or_download('test', '0.0.1', 'tar.gz')
    assert_equal file.path, '/tmp/packages/test_0.0.1.tar.gz'
  end
  
  test "cache_or_download should return file from cache path if exists" do
    FileUtils.touch '/tmp/packages/test_0.0.1'
    file = Cran.cache_or_download('test', '0.0.1')
    assert_equal file.path, '/tmp/packages/test_0.0.1'
  end
  
  test "cache_or_download should download file in missing" do
    FileUtils.rm '/tmp/packages/beefdead_0.0.1' rescue nil
    File.open('/tmp/cran/beefdead_0.0.1', 'w+') {|f| f.write('DEADBEEF') }
    file = Cran.cache_or_download('beefdead', '0.0.1')
    assert_equal file.path, '/tmp/packages/beefdead_0.0.1', 'copies files to cache folder'
    assert_equal file.read, 'DEADBEEF', 'file has same content'
  end
  
  test "fetch_index should redownload file if older than 12 hrs" do
    FileUtils.touch '/tmp/packages/PACKAGES', mtime: 13.hours.ago.to_time
    FileUtils.touch '/tmp/cran/PACKAGES'
    packages = Cran.fetch_index
    assert packages.mtime > 5.minutes.ago
  end
  
  test "fetch_index should keep file if younger than 12 hrs" do
    FileUtils.touch '/tmp/packages/PACKAGES', mtime: 11.hours.ago.to_time
    FileUtils.touch '/tmp/cran/PACKAGES'
    packages = Cran.fetch_index
    assert packages.mtime < 10.minutes.ago
  end
  
  test "fetch_package_details returns parsed data" do
    FileUtils.cp Rails.root.join('test', 'abc_1.8.tar.gz'), '/tmp/cran/'
    FileUtils.rm '/tmp/packages/abc_1.8.tar.gz' rescue nil
    package = Cran.fetch_package_details('Package' => 'abc', 'Version' => '1.8')
    assert File.exists? '/tmp/packages/abc_1.8.tar.gz'
    assert package.is_a?(Hash), 'returns hash'
    assert_equal package[:version], '1.8'
    assert_equal package[:maintainer], 'Michael Blum <michael.blum@imag.fr>'
  end
end
