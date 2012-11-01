class GridCell < AQGridViewCell

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
      
      self.addSubview(@image_view)
      self.addSubview(@title)
    end
    
    self
  end 

  def image
    @image_view.image
  end

  def setImage(anImage)
    @image_view.image = anImage
    self.setNeedsLayout
  end

  def title
    @title.text
  end

  def setTitle(title)
    @title.text = title
    self.setNeedsLayout
  end

  def layoutSubViews
    super

    p "called"

    imageSize = @image_view.image.size
    bounds = CGRectInset(self.contentView.bounds, 10.0, 10.0 )
    
    @title.sizeToFit
    frame = @title.frame
    frame.size.width = MIN(frame.size.width, bounds.size.width)
    frame.origin.y = CGRectGetMaxY(bounds) - frame.size.height
    frame.origin.x = floorf((bounds.size.width - frame.size.width) * 0.5)
    @title.frame = frame
    
    # adjust the frame down for the image layout calculation
    bounds.size.height = frame.origin.y - bounds.origin.y
    
    if ( (imageSize.width <= bounds.size.width) and (imageSize.height <= bounds.size.height) )
      return
    end
    
    # scale it down to fit
    hRatio = bounds.size.width / imageSize.width
    vRatio = bounds.size.height / imageSize.height
    ratio = MIN(hRatio, vRatio)
    
    @image_view.sizeToFit
    frame = @image_view.frame
    frame.size.width = floorf(imageSize.width * ratio)
    frame.size.height = floorf(imageSize.height * ratio)
    frame.origin.x = floorf((bounds.size.width - frame.size.width) * 0.5)
    frame.origin.y = floorf((bounds.size.height - frame.size.height) * 05);
    @image_view.frame = frame;
  end
end