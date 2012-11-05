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

  def unzip_and_load_web_view
    p "unzip"
    @webview_app = WebviewApp.new("hack2-hongkong", "https://github.com/toamitkumar/webview_shell/blob/master/resources/hack2-hongkong.zip?raw=true")
    @webview_app.unzip_and_update
  end

  def load_web_view
    @web_view_controller = App.delegate.app_web_view_controller
    navigationController.pushViewController(@web_view_controller, animated:true)
    @web_view_controller.load_web_view("hack2-hongkong", "#{App.documents_path}/hack2-hongkong/index.html")
  end

  def cell_option_selected(clicked_option)
    @cell_popover.dismissPopoverAnimated(true)

    case clicked_option
    when "Open"
      load_web_view
    when "Update"
      @progress_alert = UIAlertView.alloc.initWithTitle("Preparing to Download", message:"Please wait...", delegate:self, cancelButtonTitle:nil, otherButtonTitles:nil)

      @progress_view = UIProgressView.alloc.initWithFrame(CGRectMake(30.0, 80.0, 225.0, 90.0))
      @progress_view.setProgressViewStyle(UIProgressViewStyleBar)
      @progress_alert.addSubview(@progress_view)
      @progress_alert.show

      # TODO: fetch app details based on index and then download it

      download_service = DownloadService.new("https://github.com/toamitkumar/webview_shell/blob/master/resources/hack2-hongkong.zip?raw=true", "#{App.documents_path}/hack2-hongkong-zipfile.zip", @progress_alert)
      download_service.delegate = self
      download_service.fetch
    when "Delete"

    end
  end

  def add_application(sender)
    @alert_view = UIAlertView.alloc.initWithTitle("Add a new Application", message:nil, delegate:self, cancelButtonTitle:"Cancel", otherButtonTitles:"Add", nil)
    @alert_view.addTextFieldWithValue("", label:"Name of Application")
    @alert_view.addTextFieldWithValue("", label:"URL to download")
    @alert_view.setFrame(CGRectMake(12, 90, 260, 25))

    name = @alert_view.textFieldAtIndex(0)
    name.clearButtonMode = UITextFieldViewModeWhileEditing
    name.keyboardType = UIKeyboardTypeAlphabet
    name.keyboardAppearance = UIKeyboardAppearanceAlert
    name.autocapitalizationType = UITextAutocapitalizationTypeWords
    name.autocorrectionType = UITextAutocorrectionTypeNo

    url = @alert_view.textFieldAtIndex(1)
    url.clearButtonMode = UITextFieldViewModeWhileEditing
    url.keyboardType = UIKeyboardTypeURL
    url.keyboardAppearance = UIKeyboardAppearanceAlert
    url.autocapitalizationType = UITextAutocapitalizationTypeNone
    url.autocorrectionType = UITextAutocorrectionTypeNo

    @alert_view.show
  end

  def willPresentAlertView(alertView)
    p alertView.frame
    alertView.setFrame(CGRectMake(10, 100, 300, 320))
  end

  def alertViewShouldEnableFirstOtherButton(alertView)
    name = alertView.textFieldAtIndex(0).text
    url = alertView.textFieldAtIndex(1).text
    if(name and url)
      true
    else
      false
    end
  end

  def alertView(alertView, didDismissWithButtonIndex:buttonIndex)
    if(buttonIndex == 1)
      Apps.create_new(alertView.textFieldAtIndex(0).text, alertView.textFieldAtIndex(1).text)
      # Scenario.create(alertView.textFieldAtIndex(0).text, UserInput.instance.json_as_string)
    end
  end

  def textFieldShouldReturn(textField)
    if(textField.text.length >= 2)
      @alert_view.dismissWithClickedButtonIndex(1, animated:true)
      return true
    end
    return false
  end



end