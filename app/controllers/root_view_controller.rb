class RootViewController < UIViewController  
  def viewDidLoad
    web_view_app = App.delegate.instance_variable_get(:@webview_app)
    web_view_app.download_and_unzip

    webFrame = CGRectMake(0, 0, App.frame.size.height, App.frame.size.width)
    @root_web_view = RootWebView.alloc.initWithFrame(webFrame)
    self.view.addSubview(@root_web_view)    
  end

  def shouldAutorotateToInterfaceOrientation(interfaceOrientation)
    if(Device.ipad? and (interfaceOrientation == UIDeviceOrientationLandscapeLeft or interfaceOrientation == UIDeviceOrientationLandscapeRight))
      return true
    end
    false
  end  
end