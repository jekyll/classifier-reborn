class Vector
  def zero?
    all?(&:zero?)
  end
end
