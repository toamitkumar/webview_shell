class RootWebView < UIView

  def initWithFrame(rect)
    if(super)
      @webFrame = rect
      createWebSubView

      web_view_app = App.delegate.instance_variable_get(:@webview_app)

      loadHtml(web_view_app.html_path)
      addActivityIndicator(rect)
    end
    self
  end

  def webViewDidStartLoad(webView)
    UIView.transitionWithView(
      self, 
      duration:0.5, 
      options:UIViewAnimationOptionTransitionCrossDissolve,
      animations:lambda do
        # addActivityIndicator(@webFrame)
        self.addSubview(@indicatorContainer)
        @activityIndicator.startAnimating
      end, 
      completion:nil
    )
  end

  def webViewDidFinishLoad(webView)
    @activityIndicator.stopAnimating
    @indicatorContainer.removeFromSuperview
    self.addSubview(@webView)
    @webView.sizeToFit

    @webView.scrollView.scrollEnabled = false
    @webView.scrollView.bounces = false
  end

  def loadHtml(html_path)
    @webView.loadRequest(NSURLRequest.requestWithURL(NSURL.fileURLWithPath(html_path)))
  end

  def addActivityIndicator(rect)
    @indicatorContainer = UIView.alloc.initWithFrame(rect)
    @indicatorContainer.backgroundColor = UIColor.colorWithRed(240, green:241, blue:243, alpha:0.9)
    @activityIndicator = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleGray)
    @indicatorContainer.addSubview(@activityIndicator)
    @activityIndicator.transform = CGAffineTransformMakeScale(1.5, 1.5)
    @activityIndicator.frame = CGRectMake((rect.size.width/2)-50, (rect.size.height/2)-70, 100, 100)
  end

  def createWebSubView
    @webView = UIWebView.alloc.initWithFrame(@webFrame)
    @webView.delegate = self
  end
end