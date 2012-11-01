class GridCell < AQGridViewCell

  attr_accessor :title, :image_view

  def initWithFrame(frame, reuseIdentifier:aReuseIdentifier)
    if(super)
      @image_view = UIImageView.alloc.initWithFrame(CGRectZero)
      @title = UILabel.alloc.initWithFrame(CGRectZero)

      @title.highlightedTextColor = UIColor.whiteColor
      @title.font = UIFont.boldSystemFontOfSize(12.0)
      @title.adjustsFontSizeToFitWidth = true
      @title.minimumFontSize = 10.0

      self.backgroundColor = UIColor.colorWithWhite(0.95, alpha: 1.0)
      self.contentView.backgroundColor = self.backgroundColor
      @image_view.backgroundColor = self.backgroundColor
      @title.backgroundColor = self.backgroundColor
      
      self.contentView.addSubview(@image_view)
      self.contentView.addSubview(@title)
    end
    
    self
  end

  def setImageAndTitle(image, text)
    @image_view.image = image
    @title.text = text
    self.layoutSubViews
  end

  def layoutSubViews
    # super

    p "called"

    imageSize = @image_view.image.size
    bounds = CGRectInset(self.contentView.bounds, 10.0, 10.0 )
    
    @title.sizeToFit
    frame = @title.frame
    frame.size.width = [frame.size.width, bounds.size.width].min
    frame.origin.y = CGRectGetMaxY(bounds) - frame.size.height
    frame.origin.x = ((bounds.size.width - frame.size.width) * 0.5).floor
    @title.frame = frame
    
    # adjust the frame down for the image layout calculation
    bounds.size.height = frame.origin.y - bounds.origin.y
    
    if ( (imageSize.width <= bounds.size.width) and (imageSize.height <= bounds.size.height) )
      return
    end
    
    # scale it down to fit
    hRatio = bounds.size.width / imageSize.width
    vRatio = bounds.size.height / imageSize.height
    ratio = [hRatio, vRatio].min
    
    @image_view.sizeToFit
    frame = @image_view.frame
    frame.size.width = (imageSize.width * ratio).floor
    frame.size.height = (imageSize.height * ratio).floor
    frame.origin.x = ((bounds.size.width - frame.size.width) * 0.5).floor
    frame.origin.y = ((bounds.size.height - frame.size.height) * 05).floor
    @image_view.frame = frame
  end
end