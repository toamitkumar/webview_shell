class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)

    NanoStore.shared_store = NanoStore.store(:file, App.documents_path + "/apps.db")

    @window = UIWindow.alloc.initWithFrame(App.bounds)

    @webview_app = WebviewApp.new("hack2-hongkong", "https://github.com/toamitkumar/webview_shell/blob/master/resources/hack2-hongkong.zip?raw=true")

    # @window.rootViewController =  RootViewController.alloc.init
    # @window.rootViewController = GridViewController.alloc.init
    @window.rootViewController = GridViewController.alloc.initWithNibName("GridViewController", bundle:nil)
    
    @window.makeKeyAndVisible
    
    true
  end
end