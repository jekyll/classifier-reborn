# frozen_string_literal: true

class MatrixTest < Minitest::Test
  def test_zero_division
    skip "extensions/vector is only used by non-GSL implementation" if $GSL
    
    matrix = Matrix[[1, 0], [0, 1]]
    matrix.SV_decomp
  end
end
