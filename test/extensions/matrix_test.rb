class MatrixTest < Minitest::Test
  def test_zero_division
    matrix = Matrix[[1, 0], [0, 1]]
    matrix.SV_decomp
  end
end
