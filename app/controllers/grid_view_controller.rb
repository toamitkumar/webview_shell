class GridViewController < UIViewController #AQGridViewController 

  attr_accessor :grid_view, :images

  def initWithNibName(nib_name, bundle:bundle)
    if(super)
      @images = []

      p @images
    end
    self
  end

  def viewDidLoad
    super

    # add_toolbar
    # add_background_image

    Dir.glob("#{App.resources_path}/*.png").each do |f|
      @images << File.basename(f) if File.file?(f)
    end

    p self.view.superview

    @grid_view = self.view
    p @grid_view

    # @grid_view.setFrame(CGRectMake(50, 50, App.frame.size.height+20, App.frame.size.width))

    # @grid_view = AQGridView.alloc.init#WithFrame(CGRectMake(0, 50, App.frame.size.height+20, App.frame.size.width))
    @grid_view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight
    @grid_view.autoresizesSubviews = true

    # self.view.addSubview(@grid_view)
    @grid_view.reloadData
  end

  def add_background_image
    window_frame = CGRectMake(0, 0, App.frame.size.height+20, App.frame.size.width)

    background_image = UIImageView.alloc.initWithFrame(window_frame)
    image = UIImage.imageNamed("background.png")
    background_image.image = image
    self.view.addSubview(background_image)
  end

  def add_toolbar
    toolbar_frame = CGRectMake(0, 0, App.frame.size.height+20, 40)
    toolbar = UIToolbar.alloc.initWithFrame(toolbar_frame)
    self.view.addSubview(toolbar)
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
      cell.setSelectionStyle(AQGridViewCellSelectionStyleBlueGray)
      p cell
    end
    cell.setImageAndTitle(UIImage.imageNamed(@images[index]), @images[index])

    cell
  end

  def gridView(aGridView, didSelectItemAtIndex:index)
    cell = aGridView.dequeueReusableCellWithIdentifier("FilledCellIdentifier_#{index}")
    p cell
    @cell_popover_view = PopOverViewController.alloc.init
    @cell_popover_view.contentSizeForViewInPopover = CGSizeMake(@cell_popover_view.widthOfPopUp, @cell_popover_view.heightOfPopUp)

    @cell_popover = UIPopoverController.alloc.initWithContentViewController(@cell_popover_view)
    
    @cell_popover.presentPopoverFromRect(cell.frame, inView:cell, permittedArrowDirections:UIPopoverArrowDirectionUp, animated:true)
  end

  def portraitGridCellSizeForGridView(aGridView)
    CGSizeMake(224.0, 168.0)
  end

end