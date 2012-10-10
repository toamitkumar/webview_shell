class FileUtils

  class << self

    def rm_rf(path)
      file_manager = NSFileManager.defaultManager
      error_pointer = Pointer.new(:id)
      file_manager.removeItemAtPath(path, error:error_pointer)
    end

  end
end