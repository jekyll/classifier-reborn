# frozen_string_literal: true

class Vector
  def zero?
    all?(&:zero?)
  end
end
