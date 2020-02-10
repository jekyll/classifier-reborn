# frozen_string_literal: true

# Author::    Ernest Ellingson
# Copyright:: Copyright (c) 2005

# These are extensions to the std-lib 'matrix' to allow an all ruby SVD

require 'matrix'

class Matrix
  def self.diag(s)
    Matrix.diagonal(*s)
  end

  alias trans transpose

  def SV_decomp(maxSweeps = 20)
    q = if row_size >= column_size
          trans * self
        else
          self * trans
        end

    qrot    = q.dup
    v       = Matrix.identity(q.row_size)
    mzrot   = nil
    cnt     = 0
    s_old   = nil

    loop do
      cnt += 1
      (0...qrot.row_size - 1).each do |row|
        (1..qrot.row_size - 1).each do |col|
          next if row == col

          h = if (2.0 * qrot[row, col]) == (qrot[row, row] - qrot[col, col])
                Math.atan(1) / 2.0
              else
                Math.atan((2.0 * qrot[row, col]) / (qrot[row, row] - qrot[col, col])) / 2.0
              end
          hcos = Math.cos(h)
          hsin = Math.sin(h)
          mzrot = Matrix.identity(qrot.row_size)
          mzrot[row, row] = hcos
          mzrot[row, col] = -hsin
          mzrot[col, row] = hsin
          mzrot[col, col] = hcos
          qrot = mzrot.trans * qrot * mzrot
          v *= mzrot
        end
      end
      s_old = qrot.dup if cnt == 1
      sum_qrot = 0.0
      if cnt > 1
        qrot.row_size.times do |r|
          sum_qrot += (qrot[r, r] - s_old[r, r]).abs if (qrot[r, r] - s_old[r, r]).abs > 0.001
        end
        s_old = qrot.dup
      end
      break if (sum_qrot <= 0.001 && cnt > 1) || cnt >= maxSweeps
    end # of do while true
    s = []
    qrot.row_size.times do |r|
      s << Math.sqrt(qrot[r, r])
    end
    # puts "cnt = #{cnt}"
    if row_size >= column_size
      mu = self * v * Matrix.diagonal(*s).inverse
      return [mu, v, s]
    else
      puts v.row_size
      puts v.column_size
      puts row_size
      puts column_size
      puts s.size

      mu = (trans * v * Matrix.diagonal(*s).inverse)
      return [mu, v, s]
    end
  end

  def []=(i, j, val)
    @rows[i][j] = val
  end
end
