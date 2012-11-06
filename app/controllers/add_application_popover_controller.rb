class AddApplicationPopoverController < UITableViewController

  attr_accessor :delegate

  def heightOfPopUp
    172
  end

  def widthOfPopUp
    400
  end

  def tableView(tableView, numberOfRowsInSection:section)
    3
  end

  def tableView(tableView, cellForRowAtIndexPath:index)
    cellIdentifier = "AddApplicationCell"
    cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
    
    unless(cell)
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:cellIdentifier)
      cell.selectionStyle = UITableViewCellSelectionStyleNone
    end

    case index.row
    when 0
      @name = CustomUiTextField.create(CGRectMake(10, 2, 380, 40), "Name of Application", 1)
      @name.autocapitalizationType = UITextAutocapitalizationTypeWords
      cell.contentView.addSubview(@name)
    when 1
      @url = CustomUiTextField.create(CGRectMake(10, 2, 380, 40), "URL to download", 2)
      cell.contentView.addSubview(@url)
    when 2
      submit_button = UIButton.buttonWithType(UIButtonTypeCustom)
      submit_button.setFrame(CGRectMake(10, 2, 380, 40))
      submit_button.setBackgroundImage(UIImage.imageNamed("btn_login.png"), forState:UIControlStateNormal)
      submit_button.setTitle("Create", forState:UIControlStateNormal)
      submit_button.font = UIFont.fontWithName("Helvetica-Bold", size:20)
      submit_button.addTarget(self, action:"add_button_click:", forControlEvents:UIControlEventTouchUpInside)
      cell.contentView.addSubview(submit_button)
    end

    cell
  end

  def tableView(tableView, titleForHeaderInSection:section)
    "Add a new Application"
  end

  def tableView(tableView, heightForHeaderInSection:section)
    40
  end

  def add_button_click(sender)
    name = @name.text || ""
    url = @url.text || ""

    if(not name.empty? and not url.empty?)
      self.delegate.create_new_application(name, url)
    end
    
    @name.becomeFirstResponder and return if(name.empty?)
    @url.becomeFirstResponder if(url.empty?)
  end
end