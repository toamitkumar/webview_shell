class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)

    NanoStore.shared_store = NanoStore.store(:file, App.documents_path + "/apps.db")

    @window = UIWindow.alloc.initWithFrame(App.bounds)

    @webview_app = WebviewApp.new("hack2-hongkong", "https://github.com/toamitkumar/webview_shell/blob/master/resources/hack2-hongkong.zip?raw=true")


    @grid_controller = GridViewController.alloc.init
    @window.rootViewController = UINavigationController.alloc.initWithRootViewController(@grid_controller)
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    
    true
  end

  def app_web_view_controller
    web_frame = CGRectMake(0, 0, App.frame.size.height+20, App.frame.size.width)
    @app_web_view_controller ||= AppViewController.alloc.initWithFrame(web_frame)
  end
end