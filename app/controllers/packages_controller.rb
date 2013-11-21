class PackagesController < ApplicationController

  # GET /packages
  # GET /packages.json
  def index
    @packages = Package.all
    unless params[:search].blank?
      @packages = @packages.where('lower(name) LIKE ?', "%#{params[:search].downcase}%")
    end
  end

  # GET /packages/1
  # GET /packages/1.json
  def show
    @package = Package.find(params[:id])
    @package_versions = @package.versions
  end

end
