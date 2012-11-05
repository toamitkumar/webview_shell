class GridViewController < AQGridViewController 

  attr_accessor :grid_view, :images, :selected_cell_index

  def initWithNibName(nib_name, bundle:bundle)
    if(super)
      @images = []
      navigationItem.title = "Applications"
      navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:"add_application:")
    end
    self
  end

  def viewDidLoad

    # add_background_image

    @grid_view = self.view
    # @grid_view.contentInset = UIEdgeInsetsMake(0.0, 0.0, 12.0, 0.0)
    # @grid_view.rightContentInset = 12.0
    # @grid_view.resizesCellWidthToFit = true

    Dir.glob("#{App.resources_path}/*.png").each do |f|
      @images << File.basename(f) if File.file?(f)
    end

    p @images

    @grid_view.reloadData

    super
  end

  def add_background_image
    window_frame = CGRectMake(0, 0, App.frame.size.height+20, App.frame.size.width)

    background_image = UIImageView.alloc.initWithFrame(window_frame)
    image = UIImage.imageNamed("background.png")
    background_image.image = image
    self.view.addSubview(background_image)
  end

  def shouldAutorotateToInterfaceOrientation(interfaceOrientation)
    if(Device.ipad? and (interfaceOrientation == UIDeviceOrientationLandscapeLeft or interfaceOrientation == UIDeviceOrientationLandscapeRight))
      return true
    end
    false
  end

  def numberOfItemsInGridView(aGridView)
    @images.size
  end

  def gridView(aGridView, cellForItemAtIndex:index)
    cell = aGridView.dequeueReusableCellWithIdentifier("FilledCellIdentifier_#{index}")

    unless(cell)
      cell = GridCell.alloc.initWithFrame(CGRectMake(0.0, 0.0, 200.0, 150.0), reuseIdentifier:"FilledCellIdentifier_#{index}")
    end
    cell.setImageAndTitle(UIImage.imageNamed(@images[index]), @images[index])

    cell
  end

  def gridView(aGridView, didSelectItemAtIndex:index)
    cell = aGridView.cellForItemAtIndex(index)
    @cell_popover_view = PopOverViewController.alloc.init
    @cell_popover_view.contentSizeForViewInPopover = CGSizeMake(@cell_popover_view.widthOfPopUp, @cell_popover_view.heightOfPopUp)
    @cell_popover_view.delegate = self
    @selected_cell_index = index

    @cell_popover = UIPopoverController.alloc.initWithContentViewController(@cell_popover_view)
    
    @cell_popover.presentPopoverFromRect(cell.image_view.frame, inView:cell, permittedArrowDirections:UIPopoverArrowDirectionUp, animated:true)
  end

  def portraitGridCellSizeForGridView(aGridView)
    CGSizeMake(253.0, 184.0)
  end

  def cell_option_selected(clicked_option)
    p clicked_option
    case clicked_option
    when "Open"

    when "Update"
      @progress_alert = UIAlertView.alloc.initWithTitle("Preparing to Download", message:"Please wait...", delegate:self, cancelButtonTitle:nil, otherButtonTitles:nil)

      @progress_view = UIProgressView.alloc.initWithFrame(CGRectMake(30.0, 80.0, 225.0, 90.0))
      @progress_view.setProgressViewStyle(UIProgressViewStyleBar)
      @progress_alert.addSubview(@progress_view)
      @progress_alert.show

      DownloadService.new("https://github.com/toamitkumar/webview_shell/blob/master/resources/hack2-hongkong.zip?raw=true", @progress_alert).fetch
    when "Delete"

    end
  end

  def add_application(sender)

  end

end