class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)

    @window = UIWindow.alloc.initWithFrame(App.bounds)

    @webview_app = WebviewApp.new("hack2-hongkong", "https://github.com/toamitkumar/webview_shell/blob/master/resources/hack2-hongkong.zip?raw=true")

    @window.rootViewController =  RootViewController.alloc.init
    @window.makeKeyAndVisible
    
    true
  end
end
