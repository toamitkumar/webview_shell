class AppViewController < UIViewController

  def initWithFrame(rect)
    @web_frame = rect
    # if(super)

    # end
    self
  end

  def loadView
    # self.view = RootWebView.alloc.initWithFrame(@web_frame)
  end

  def load_web_view(name, html_path)
    navigationItem.title = name
    self.view = RootWebView.alloc.initWithFrame(@web_frame)
  end

end