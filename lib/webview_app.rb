class WebviewApp

  attr_accessor :name, :url, :html_path, :app_path, :zip_path

  def initialize(_name, _url)
    @name = _name
    @url = _url
    @app_path = "#{App.documents_path}/#{name}"
    @zip_path = "#{App.documents_path}/#{name}.zip"
  end

  def delete_directory
    FileUtils.rm_rf(App.resources_path+"/#{name}")
  end

  def download_and_unzip
    # fetch

    delete_directory

    file_archive = ZKFileArchive.archiveWithArchivePath(zip_path)
    file_archive.inflateToDirectory(app_path, usingResourceFork:false)

    # archivePath = NSBundle.mainBundle.pathForResource(name, ofType:'zip')
    # ZKFileArchive.process(archivePath, usingResourceFork:true, withInvoker:self, andDelegate:nil)

    @html_path = NSBundle.mainBundle.pathForResource("index", ofType:"html", inDirectory: name)
  end

  def fetch
    zip_data = NSData.dataWithContentsOfURL(NSURL.URLWithString(@url))

    file_manager = NSFileManager.defaultManager
    file_manager.createFileAtPath(zip_path, contents:zip_data, attributes:nil)
  end

end