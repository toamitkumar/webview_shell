class GridViewController < AQGridViewController 

  attr_accessor :grid_view, :webview_apps, :selected_app_uuid, :selected_cell_index

  def initWithNibName(nib_name, bundle:bundle)
    if(super)
      @webview_apps = []
      # @images = []
      navigationItem.title = "Applications"
      navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:"show_application_popover:")
    end
    self
  end

  def loadView
    super

    @grid_view = self.view
    navigationController.navigationBar.tintColor = UIColor.colorWithRed(0.18, green:0.29, blue:0.42, alpha:1.0)
    @webview_apps = WebviewApp.all

    @grid_view.reloadData
  end

  def viewDidLoad
    super

    add_background_image
  end

  def add_background_image
    window_frame = CGRectMake(0, 0, App.frame.size.height+20, App.frame.size.width)

    background_image = UIImageView.alloc.initWithFrame(window_frame)
    image = UIImage.imageNamed("background.png")
    background_image.image = image
    @grid_view.setBackgroundView(background_image)
  end

  def shouldAutorotateToInterfaceOrientation(interfaceOrientation)
    true
  end

  def numberOfItemsInGridView(aGridView)
    @webview_apps.size
    # @images.size
  end

  def gridView(aGridView, cellForItemAtIndex:index)
    cell = aGridView.dequeueReusableCellWithIdentifier("FilledCellIdentifier_#{index}")

    unless(cell)
      cell = GridCell.alloc.initWithFrame(CGRectMake(0.0, 0.0, 200.0, 150.0), reuseIdentifier:"FilledCellIdentifier_#{index}")
    end
    image_data = NSData.alloc.initWithContentsOfFile(@webview_apps[index].icon_path)
    image = UIImage.alloc.initWithData(image_data)

    cell.app_uuid = @webview_apps[index].key
    cell.setImageAndTitle(image, @webview_apps[index].name)

    # cell.setImageAndTitle(UIImage.imageNamed(@images[index]), @images[index])

    cell
  end

  def gridView(aGridView, didSelectItemAtIndex:index)
    cell = aGridView.cellForItemAtIndex(index)
    @cell_popover_view = CellMenuPopoverController.alloc.init
    @cell_popover_view.contentSizeForViewInPopover = CGSizeMake(@cell_popover_view.widthOfPopUp, @cell_popover_view.heightOfPopUp)
    @cell_popover_view.delegate = self
    @selected_app_uuid = cell.app_uuid
    @selected_cell_index = index

    @cell_popover = UIPopoverController.alloc.initWithContentViewController(@cell_popover_view)
    @cell_popover.delegate = self
    
    @cell_popover.presentPopoverFromRect(cell.image_view.frame, inView:cell, permittedArrowDirections:UIPopoverArrowDirectionUp, animated:true)
  end

  def popoverControllerDidDismissPopover(popoverController)
    if(popoverController == @cell_popover)
      @grid_view.deselectItemAtIndex(@selected_cell_index, animated:true)
    end
  end

  def portraitGridCellSizeForGridView(aGridView)
    CGSizeMake(253.0, 184.0)
  end

  def download_and_refresh(app)
    download(app)
    @download_observer = App.notification_center.observe "DownloadCompletedNotification" do |notification|
      app.unzip_and_update
      @webview_apps = WebviewApp.all

      @grid_view.reloadData
    end
  end

  def delete_and_refresh(app)
    app.delete
    @webview_apps = WebviewApp.all

    @grid_view.reloadData
  end

  def download(app)
    @progress_alert = UIAlertView.alloc.initWithTitle("Preparing to Download", message:"Please wait...", delegate:self, cancelButtonTitle:nil, otherButtonTitles:nil)

    @progress_view = UIProgressView.alloc.initWithFrame(CGRectMake(30.0, 80.0, 225.0, 90.0))
    @progress_view.setProgressViewStyle(UIProgressViewStyleBar)
    @progress_alert.addSubview(@progress_view)
    @progress_alert.show

    download_service = DownloadService.new(app.zip_file_url, app.zip_path, @progress_alert)
    download_service.delegate = self
    download_service.fetch
  end

  def load_web_view(app)
    @web_view_controller = App.delegate.app_web_view_controller
    navigationController.pushViewController(@web_view_controller, animated:true)
    @web_view_controller.load_web_view(app.name, app.html_path)
  end

  def cell_option_selected(clicked_option)
    app = WebviewApp.find_by_key(@selected_app_uuid)
    @grid_view.deselectItemAtIndex(@selected_cell_index, animated:true)

    close_popover(@cell_popover)

    case clicked_option
    when "Open"
      load_web_view(app)
    when "Update"
      download_and_refresh(app)
    when "Delete"
      delete_and_refresh(app)
    end
  end

  def show_application_popover(sender)
    if(@add_popover.nil? or not @add_popover.isPopoverVisible)
      @add_popover_view = AddApplicationPopoverController.alloc.init
      @add_popover_view.contentSizeForViewInPopover = CGSizeMake(@add_popover_view.widthOfPopUp, @add_popover_view.heightOfPopUp)
      @add_popover_view.delegate = self

      @add_popover = UIPopoverController.alloc.initWithContentViewController(@add_popover_view)
      
      @add_popover.presentPopoverFromBarButtonItem(sender, permittedArrowDirections:UIPopoverArrowDirectionUp, animated:true)
    else
      close_popover(@add_popover) if(@add_popover)
    end
  end

  def create_new_application(name, url)
    close_popover(@add_popover)
    app = WebviewApp.create_new(name, url)
    download_and_refresh(app)
  end

  def close_popover(popover)
    if(popover)
      popover.dismissPopoverAnimated(true)
      popover = nil
    end
  end

end