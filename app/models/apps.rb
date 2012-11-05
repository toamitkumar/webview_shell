class Apps < NanoStore::Model

  attribute :name
  attribute :zip_file_url
  attribute :app_path
  attribute :zip_path
  attribute :created_at
  attribute :updated_at

  def self.create_new(_name, _url)
    create(
      :name => _name, 
      :zip_file_url => _url, 
      :app_path => "#{App.documents_path}/#{_name}",
      :zip_path => "#{App.documents_path}/#{_name}-zipfile.zip",
      :created_at => Time.now,
      :updated_at => Time.now
    )
  end

  def html_path
    "#{app_path}/index.html"
  end
  
end