class WebviewApp < NanoStore::Model

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

  def self.find_by_key(key)
    search = NSFNanoSearch.searchWithStore(self.store)
    search.key = key

    error_ptr = Pointer.new(:id)
    searchResult = search.searchObjectsWithReturnType(NSFReturnObjects, error:error_ptr).first
    raise NanoStoreError, error_ptr[0].description if error_ptr[0]

    searchResult.last if searchResult
  end

  def icon_path
    path = "#{app_path}/#{name}.png"
    unless(File.file?(path))
      path = "#{App.resources_path}/blank_image.png"
    end
    path
  end

  def unzip_and_update
    delete_at(app_path)

    file_archive = ZKFileArchive.archiveWithArchivePath(zip_path)
    file_archive.inflateToDirectory("#{app_path}1", usingResourceFork:false)
  end

  def html_path
    "#{app_path}/index.html"
  end

  private
    def delete_at(path)
      FileUtils.rm_rf(path)
    end
  
end