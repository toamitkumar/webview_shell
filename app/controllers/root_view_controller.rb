class RootViewController < UIViewController  
  def viewDidLoad
    @web_frame = CGRectMake(0, 0, App.frame.size.height, App.frame.size.width)

    # addIndicator
    # pushToQueue
    download_and_unzip
  end

  def shouldAutorotateToInterfaceOrientation(interfaceOrientation)
    if(Device.ipad? and (interfaceOrientation == UIDeviceOrientationLandscapeLeft or interfaceOrientation == UIDeviceOrientationLandscapeRight))
      return true
    end
    false
  end  

  def pushToQueue
    p "pushToQueue"
    queue = NSOperationQueue.new
    operation = NSInvocationOperation.alloc.initWithTarget(self, selector:"download_and_unzip", object:nil)
    queue.addOperation(operation)
  end

  def download_and_unzip
    p "download_and_unzip"

    @web_view_app = App.delegate.instance_variable_get(:@webview_app)
    fetch(@web_view_app.url, @web_view_app.zip_path)
    @web_view_app.unzip_and_update

    load_web_view
    # self.performSelectorOnMainThread("load_web_view", withObject:nil, waitUntilDone:true)
  end

  def load_web_view
    @indicatorContainer.removeFromSuperview
    @root_web_view = RootWebView.alloc.initWithFrame(@web_frame)
    self.view.addSubview(@root_web_view)
  end

  def addIndicator
    @indicatorContainer = UIView.alloc.initWithFrame(@web_frame)
    @indicatorContainer.backgroundColor = UIColor.colorWithRed(240, green:241, blue:243, alpha:0.9)
    @activityIndicator = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleGray)
    @indicatorContainer.addSubview(@activityIndicator)
    @activityIndicator.transform = CGAffineTransformMakeScale(1.5, 1.5)
    @activityIndicator.frame = CGRectMake((@web_frame.size.width/2)-50, (@web_frame.size.height/2)-70, 100, 100)

    UIView.transitionWithView(
      self.view, 
      duration:0.5, 
      options:UIViewAnimationOptionTransitionCrossDissolve,
      animations:lambda do
        # addActivityIndicator(@webFrame)
        self.view.addSubview(@indicatorContainer)
        @activityIndicator.startAnimating
      end, 
      completion:nil
    )
  end

  def fetch(url, zip_path)
    @response_data = 
    ns_url_request = NSURLRequest.requestWithURL(NSURL.URLWithString(url))
    ns_url_connection = NSURLConnection.alloc.initWithRequest(ns_url_request, delegate:self)

    ns_url_connection.start

    # zip_data = NSData.dataWithContentsOfURL(NSURL.URLWithString(url))

    # file_manager = NSFileManager.defaultManager
    # file_manager.createFileAtPath(zip_path, contents:zip_data, attributes:nil)
  end


  # NSURLConnection Delegate START
  def connection(connection, didReceiveResponse:response)
    @web_view_app.response_data.setLength(0)
    @file_size = NSNUmber.numberWithLong(response.expectedContentLength)
  end

  def connection(connection, didReceiveData:data)
    @web_view_app.response_data.appendData(data)
    current_length = NSNUmber.numberWithLong(@web_view_app.response_data.length)
    progress = current_length.floatValue / @file_size

    # @progress_view.progress = progress
  end

  def connection(connection, didFailWithError:error)
    p "Failed to load"
  end

  def connectionDidFinishLoading(connection)
    p "Completed download"

    file_manager = NSFileManager.defaultManager
    file_manager.createFileAtPath(@web_view_app.zip_path, contents:@web_view_app.response_data, attributes:nil)
  end

  # NSURLConnection Delegate END
end