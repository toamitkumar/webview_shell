class AppViewController < UIViewController

  def initWithFrame(rect)
    @web_frame = rect
    # if(super)

    # end
    self
  end

  def load_web_view(name, html_path)
    navigationItem.title = name
    self.view = RootWebView.load(@web_frame, html_path)
  end

end