class Package < ActiveRecord::Base
  has_many :versions, class_name: 'PackageVersion', dependent: :destroy
  
  def to_s
    self.name
  end
end
