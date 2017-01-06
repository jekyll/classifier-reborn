## HEAD
## Major Enhancements
 * Bayes integration test of Memory and Redis backends with real data ([#92](https://github.com/jekyll/classifier-reborn/pull/92))
 * Memory and Redis backend support ([#84](https://github.com/jekyll/classifier-reborn/pull/84))

### Minor Enhancements
 * Disabled Redis disc persistence and refactored integration test ([#97](https://github.com/jekyll/classifier-reborn/pull/97))
 * Removed useless intermediate variables ([#90](https://github.com/jekyll/classifier-reborn/pull/90))

## 2.1.0 / 2017-01-01
### Major Enhancements
 * Fix breaking changes in LSI api. Displays errors instead of raising where possible. #87

## 2.0.5 / 2016-12-30 - removed due to breaking change, and no longer available
### Major Enhancements
 * Stopwords get encoded to utf8 (#83)
 * Fix searching issues where no document is added to lsi (#77)
 * Added method to add custom path to user-created stopword directory (#73)

### Minor Enhancements
 * Test newer rubies (#85)
 * Fixed errors in README (#68, #79, #80)
 * Added an option to the bayesian classifier to disable word stemming (#61)
 * Added missing parens and renamed some variables (#59)

## 2.0.4 / 2015-10-31

### Major Enhancements

 * Classification thresholds can be enabled or disabled. The default is disabled. The threshold value can be set at initialization time or dynamically during processing (#47)
 * Made auto-categorization optional, defaulting to false (#45)
 * Added the ability to handle an array of classifications to the constructor (#44)
 * Classification with a threshold has been added to the api (#39)

### Minor Enhancements
  * Documentation around threshold usage (#54)
  * Fixed UTF-8 encoding for `hasher.rb` (#50)
  * Removed some unnecessary methods (#43)
  * Add optional `CachedContentNode` (GSL only) (#43)
  * Caches the transposed `search_vector` (#43)
  * Added custom marshal_ methods to not save the cache when dumping/loading (#43)
  * Optimized some numeric comparisons and iterators (#43)
  * Added cached calculation table when computing raw_vectors (#43)
  * If a category name is already a symbol, just return it (#45)
  * Various Hash improvements (#45)
  * Eliminated several Ruby :warning:s when run with RUBYOPT="-w" (#38)
  * Simple performance improvements for the Hasher process (#41)
  * Fixes for broken regex splitting for non-ascii characters and removal of the unused punctuation filter (#41)
  * Add multiple language stopwords with customizable stop word paths (#40)

### Bug Fixes

  * Fixed the bug where adding the same category a second time would clobber the category that was already there (#45)
  * Fixed deprecation warning for `<=>` in ls.rb (#33)
  * Remove references to Madeline in the README and replace it with Marshal or Redis (#32)

### Development Fixes

  * Added development dependency on `mini_test` and added 2.2 to travis.yml (#36)

## 2.0.3 / 2014-12-23

### Bug Fixes

  * Handle `GSL::Vector`'s which don't have `#reduce` in `ContentNode#raw_vector_with` (#28)
  * Remove unnecessary `Vector` monkey-patch (#29)

## 2.0.2 / 2014-11-08

### Minor Enhancements

  * Remove `Array#sum` monkey patch in favour of `#reduce(0, :+)` (#20)
  * Cache total word counts per category for speed (#4)

### Development Fixes

  * Add a test for `Bayes#untrain_*`. (#21)
  * Fix link to rb-gsl gem (#24)
  * Add helper scripts per Jekyll convention (#25)

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
