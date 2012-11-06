class String

  def blank?
    return true if(self.nil?) 
    return true if(self == "")
    false
  end

end