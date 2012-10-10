class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)

    @window = UIWindow.alloc.initWithFrame(App.bounds)

    @webview_app = WebviewApp.new("hack2-hongkong", "")

    @window.rootViewController =  RootViewController.alloc.init
    @window.makeKeyAndVisible
    
    true
  end
end
