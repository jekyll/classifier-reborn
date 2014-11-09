## HEAD

### Minor Enhancements

  * Remove `Array#sum` monkey patch in favour of `#reduce(0, :+)` (#20)
  * Cache total word counts per category for speed (#4)

### Development Fixes

  * Add a test for `Bayes#untrain_*`. (#21)
  * Fix link to rb-gsl gem (#24)

## 2.0.1 / 2014-08-14

### Bug Fixes

  * Replace `Object` monkey patch with `CategoryNamer` method (#18)
  * Count total unique words using methods supported by `Vector` and `GSL::Vector` (#11)

### Development Fixes

  * Remove `stats` rake task (#17)
  * Add some tests for `ClassifierRebord::WordList` (#15)

## 2.0.0 / 2014-08-13

### Bug Fixes

  * Remove mathn dependency (#8)
  * Only perform first order transform if total UNIQUE words is greater than 1 (#3)
  * Update `LSI#remove_item` such that they will work with the `@items` hash. (#2)

### Development Fixes

  * Exclude Gemfile.lock in .gitignore (#7)
