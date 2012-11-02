class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)

    NanoStore.shared_store = NanoStore.store(:file, App.documents_path + "/apps.db")

    @window = UIWindow.alloc.initWithFrame(App.bounds)

    @webview_app = WebviewApp.new("hack2-hongkong", "https://github.com/toamitkumar/webview_shell/blob/master/resources/hack2-hongkong.zip?raw=true")

    # @window.rootViewController =  RootViewController.alloc.init
    # @grid_controller = GridViewController.alloc.init
    # @window.rootViewController = @grid_controller

    # p @window.rootViewController
    # @window.addSubview(@grid_controller.view)
    # @window.rootViewController = GridViewController.alloc.initWithNibName("GridViewController", bundle:nil)
    
    # @window.makeKeyAndVisible

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    storyboard = UIStoryboard.storyboardWithName("MainStoryBoard", bundle:nil)
    @rootVC = storyboard.instantiateViewControllerWithIdentifier("GridViewController")

    @window.rootViewController = @rootVC
    @window.makeKeyAndVisible
    
    true
  end

  # def window
  #   @window
  # end
  
  # def setWindow(window)
  #   @window = window
  # end
end