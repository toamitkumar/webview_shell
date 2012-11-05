class DownloadService
  attr_accessor :delegate

  def initialize(_url, _alert)
    @url = _url
    @progress_alert = _alert

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

    p @progress_alert.subviews
    @progress_alert.subviews[0].progress = progress
  end

  def connection(connection, didFailWithError:error)
    p "Failed to load"
  end

  def connectionDidFinishLoading(connection)
    p "Completed download"
    @progress_alert.dismissWithClickedButtonIndex(0, animated:true)

    # file_manager = NSFileManager.defaultManager
    # file_manager.createFileAtPath(zip_path, contents:@response_data, attributes:nil)
    # load_web_view
  end

  # NSURLConnection Delegate END

  private
    def delete_at(path)
      FileUtils.rm_rf(path)
    end
end