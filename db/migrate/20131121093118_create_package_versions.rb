class CreatePackageVersions < ActiveRecord::Migration
  def change
    create_table :package_versions do |t|
      t.belongs_to :package, index: true
      t.string :version, index: true
      t.string :r_version
      t.text :dependencies
      t.text :suggestions
      t.date :publication
      t.string :title
      t.text :description
      t.text :author
      t.text :maintainer
      t.string :license

      t.timestamps
    end
  end
end
