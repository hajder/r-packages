require 'test_helper'

class PackageTest < ActiveSupport::TestCase
  test "to_s should return name" do
    package = Package.new name: 'asdf'
    assert_equal "asdf", "#{package}"
  end
end
