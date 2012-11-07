class FileUtils

  class << self

    def rm_rf(path)
      file_manager = NSFileManager.defaultManager
      error_pointer = Pointer.new(:id)
      file_manager.removeItemAtPath(path, error:error_pointer)
    end

    def mkdir(path, attributes=nil)
      file_manager = NSFileManager.defaultManager
      file_manager.createDirectoryAtPath(path, attributes:attributes)
    end

    def mv(src_path, dest_path)
      file_manager = NSFileManager.defaultManager
      error_pointer = Pointer.new(:id)
      file_manager.moveItemAtPath(src_path, toPath:dest_path, error:error_pointer)
    end
  end
end