class RootViewController < UITableViewController

  attr_accessor :archive

  def init
    if(super)
      archivePath = NSBundle.mainBundle.pathForResource("ZipKitTest", ofType:'zip')
      @archive = ZKDataArchive.archiveWithArchivePath(archivePath)
      @archive.inflateAll
      # @archive.inflateToDiskUsingResourceFork(false)
    end
    self
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    @archive.inflatedFiles.count    
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cellIdentifier = "Cell"
    cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)

    unless(cell)
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:cellIdentifier)
    end

    entry = @archive.inflatedFiles[indexPath.row]
    p entry
    cell.textLabel.text = entry[ZKPathKey]
    # cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    cell
  end
end