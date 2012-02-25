class String
  def ellipsis_if_longer_than(length)
    if self.length > length
      "#{self[0..length-4]}..."
    else
      self
    end
  end

  def ellipsis_if_longer_than!(length)
    replace ellipsis_if_longer_than(length)
  end
end