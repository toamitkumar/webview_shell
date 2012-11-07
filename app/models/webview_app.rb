class WebviewApp < NanoStore::Model

  attribute :name
  attribute :zip_file_url
  attribute :app_path
  attribute :zip_path
  attribute :created_at
  attribute :updated_at

  def self.create_new(_name, _url)
    app = create(
      :name => _name, 
      :zip_file_url => _url, 
      :created_at => Time.now,
      :updated_at => Time.now
    )
    FileUtils.mkdir("#{App.documents_path}/#{app.key}")
    # FileUtils.mkdir("#{App.documents_path}/#{app.key}/#{_name}")

    app.app_path = "#{App.documents_path}/#{app.key}/#{_name}"
    app.zip_path = "#{App.documents_path}/#{app.key}/#{_name}-zipfile.zip"
    app.save
  end

  def delete_with_remove_directory
    temp_app_path = app_path
    key_path = "#{App.documents_path}/#{key}"
    if(delete_without_remove_directory)
      delete_at(temp_app_path)
      delete_at(key_path)
    end
  end
  alias_method :delete_without_remove_directory, :delete
  alias_method :delete, :delete_with_remove_directory

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

    FileUtils.mkdir("#{App.documents_path}/#{key}/#{name}")
    file_archive = ZKFileArchive.archiveWithArchivePath(zip_path)
    file_archive.inflateToDirectory("#{App.documents_path}/#{key}/#{name}", usingResourceFork:false)

    file_manager = NSFileManager.defaultManager
    contents = file_manager.contentsOfDirectoryAtPath("#{App.documents_path}/#{key}", error:nil)

    contents.each do |content|
      if(File.directory?("#{App.documents_path}/#{key}/#{content}") and name != content)
        FileUtils.mv("#{App.documents_path}/#{key}/#{content}", "#{App.documents_path}/#{key}/#{name}")   
      end
    end
  end

  def html_path
    "#{app_path}/index.html"
  end

  private
    def delete_at(path)
      FileUtils.rm_rf(path)
    end
  
end