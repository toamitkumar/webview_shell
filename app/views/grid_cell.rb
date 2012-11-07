class GridCell < AQGridViewCell

  attr_accessor :title, :image_view, :app_uuid

  def initWithFrame(frame, reuseIdentifier:aReuseIdentifier)
    if(super)
      @image_view = UIImageView.alloc.initWithFrame(CGRectZero)
      @title = UILabel.alloc.initWithFrame(CGRectZero)

      @title.highlightedTextColor = UIColor.whiteColor
      @title.font = UIFont.boldSystemFontOfSize(12.0)
      @title.adjustsFontSizeToFitWidth = false
      @title.textAlignment = UITextAlignmentCenter
      @title.minimumFontSize = 10.0

      self.backgroundColor = UIColor.colorWithWhite(0.95, alpha: 1.0)
      self.contentView.backgroundColor = self.backgroundColor
      @image_view.backgroundColor = self.backgroundColor
      @title.backgroundColor = self.backgroundColor
      
      self.selectionStyle = AQGridViewCellSelectionStyleBlueGray
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
    imageSize = @image_view.image.size
    bounds = CGRectInset(self.contentView.bounds, 4.0, 4.0)
    
    @title.sizeToFit
    frame = @title.frame
    frame.size.width = [frame.size.width, bounds.size.width].min
    frame.origin.y = CGRectGetMaxY(bounds) - frame.size.height
    frame.origin.x = ((bounds.size.width - frame.size.width) * 0.5).floor
    @title.frame = frame
            
    @image_view.sizeToFit
    frame = @image_view.frame
    bounds = self.contentView.bounds
    frame.size.width = bounds.size.width
    frame.size.height = bounds.size.height - 25
    frame.origin.x = 0
    frame.origin.y = 0
    @image_view.frame = frame
  end
end