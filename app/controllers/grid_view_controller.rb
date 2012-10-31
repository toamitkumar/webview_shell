class GridViewController < AQGridViewController 

  attr_accessor :grid_view

  def viewDidLoad
    super

    @grid_view = AQGridView.alloc.init
    @grid_view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight
    @grid_view.autoresizesSubviews = true
    @grid_view.delegate = self
    @grid_view.dataSource = self

    @web_frame = CGRectMake(0, 0, App.frame.size.height+20, App.frame.size.width)

    background_image = UIImageView.alloc.initWithFrame(@web_frame)
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
    1
  end

  def gridView(aGridView, cellForItemAtIndex:index)
    cell = nil

    plainCell = 
  end

  def portraitGridCellSizeForGridView(aGridView)
    CGSizeMake(224.0, 168.0)
  end

end