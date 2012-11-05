class DownloadService
  attr_accessor :delegate

  def initialize(_url, _file_path, _alert)
    @url = _url
    @progress_alert = _alert
    @file_path = _file_path

    @response_data = NSMutableData.alloc.init
  end

  def fetch
    ns_url_request = NSURLRequest.requestWithURL(NSURL.URLWithString(@url))
    ns_url_connection = NSURLConnection.alloc.initWithRequest(ns_url_request, delegate:self)

    ns_url_connection.start
  end

  # NSURLConnection Delegate START
  def connection(connection, didReceiveResponse:response)
    p "didReceiveResponse"
    @response_data.setLength(0)
    @file_size = NSNumber.numberWithLong(response.expectedContentLength)
    @progress_alert.title = "Downloading"
  end

  def connection(connection, didReceiveData:data)
    p "didReceiveData"
    @response_data.appendData(data)
    current_length = NSNumber.numberWithLong(@response_data.length)
    progress = current_length.floatValue / @file_size

    @progress_alert.subviews[3].progress = progress
  end

  def connection(connection, didFailWithError:error)
    p "Failed to load"
  end

  def connectionDidFinishLoading(connection)
    p "Completed download"
    @progress_alert.dismissWithClickedButtonIndex(0, animated:true)

    file_manager = NSFileManager.defaultManager
    file_manager.createFileAtPath(@file_path, contents:@response_data, attributes:nil)
    p @file_path
    self.delegate.unzip_and_load_web_view
  end

  # NSURLConnection Delegate END
end