class Vector
  def zero?
    self.all? {|_| _ == 0}
  end
end
