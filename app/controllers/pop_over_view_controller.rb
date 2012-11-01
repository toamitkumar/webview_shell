class PopOverViewController < UITableViewController

  attr_accessor :options, :delegate

  def init
    if(super)
      @options = ["Open", "Update", "Delete"]
    end
    self
  end

  def heightOfPopUp
    140
  end

  def widthOfPopUp
    200
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @options.size
  end

  def tableView(tableView, cellForRowAtIndexPath:index)
    cellIdentifier = "PopupCell"
    cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
    
    unless(cell)
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellSelectionStyleBlue, reuseIdentifier:cellIdentifier)
    end

    cell.textLabel.text = @options[index.row]    

    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:index)
    p @options[index.row] 
  end
end