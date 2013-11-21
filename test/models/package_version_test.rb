require 'test_helper'

module Cran
  CRAN_URI = '/tmp/cran/'
  
  def self.cache_path(filename)
    '/tmp/packages/' + filename
  end
end

class PackageVersionTest < ActiveSupport::TestCase
  test "find_or_create_with_cran returns existing record" do
    version = Package.find_by(latest_version: '1.0').versions.find_or_create_with_cran('Version' => '1.0')
    assert_equal version, Package.find_by(latest_version: '1.0').versions.first
    assert_equal version.version, '1.0'
  end
  
  test "find_or_create_with_cran fills attributes from CRAN" do
    FileUtils.cp Rails.root.join('test', 'AFLPsim_0.2-2.tar.gz'), '/tmp/cran/'
    package = Package.create(name: 'AFLPsim')
    version = package.versions.find_or_create_with_cran('Package' => 'AFLPsim', 'Version' => '0.2-2')
    assert_equal version.license, 'GPL (>= 2)'
    assert_equal version.dependencies, 'R (>= 2.15.0)'
    assert_equal version.title, 'Hybrid simulation and genome scan for dominant markers'
  end
  
  test "find_or_create_with_cran removes utf incompatible characters" do
    FileUtils.cp Rails.root.join('test', 'AFLPsim_0.2-2.tar.gz'), '/tmp/cran/'
    package = Package.create(name: 'AFLPsim')
    version = package.versions.find_or_create_with_cran('Package' => 'AFLPsim', 'Version' => '0.2-2')
    assert_equal version.author, 'Francisco Balao [aut, cre], Juan Luis Garc?a-Casta?o [aut]'
  end
  
  test "should update package latest_version after save" do
    package = Package.create(name: 'MZSpack')
    assert_nil package.latest_version
    package.versions.create(version: '1.0')
    assert_equal package.reload.latest_version, '1.0'
    package.versions.create(version: '2.0')
    assert_equal package.reload.latest_version, '2.0'
    package.versions.create(version: '1.5')
    assert_equal package.reload.latest_version, '2.0'
  end
end
