class RootViewController < UIViewController  
  def viewDidLoad
    @web_frame = CGRectMake(0, 0, App.frame.size.height, App.frame.size.width)

    addIndicator
    pushToQueue
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
    web_view_app = App.delegate.instance_variable_get(:@webview_app)
    web_view_app.download_and_unzip
    self.performSelectorOnMainThread("load_web_view", withObject:nil, waitUntilDone:true)
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
end