class WebviewApp

  attr_accessor :name, :url, :html_path, :app_path, :zip_path

  def initialize(_name, _url)
    @name = _name
    @url = _url
    @app_path = "#{App.documents_path}/#{name}"
    @zip_path = "#{App.documents_path}/#{name}.zip"
  end

  def download_and_unzip
    fetch
    delete_at(app_path)

    p zip_path

    file_archive = ZKFileArchive.archiveWithArchivePath(zip_path)
    p file_archive
    p app_path
    file_archive.inflateToDirectory("#{app_path}1", usingResourceFork:false)

    # archivePath = NSBundle.mainBundle.pathForResource(name, ofType:'zip')
    # ZKFileArchive.process(archivePath, usingResourceFork:true, withInvoker:self, andDelegate:nil)

    # @html_path = NSBundle.mainBundle.pathForResource("index", ofType:"html", inDirectory: name)
    @html_path = "#{app_path}/index.html"
    p html_path
  end

  def fetch
    p @url
    p zip_path
    delete_at(zip_path)
    zip_data = NSData.dataWithContentsOfURL(NSURL.URLWithString(@url))

    file_manager = NSFileManager.defaultManager
    file_manager.createFileAtPath(zip_path, contents:zip_data, attributes:nil)
  end

  private
    def delete_at(path)
      FileUtils.rm_rf(path)
    end

end