# frozen_string_literal: true

class ZeroVectorTest < Minitest::Test
  def test_zero?
    skip "extensions/zero_vector is only used by non-GSL implementation" if $SVD != :ruby

    vec0 = Vector[]
    vec1 = Vector[0]
    vec10 = Vector.elements [0] * 10
    assert vec0.zero?
    assert vec1.zero?
    assert vec10.zero?
  end
end
