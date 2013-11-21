json.array!(@packages) do |package|
  json.extract! package, :name, :latest_version
  json.url package_url(package, format: :json)
end
