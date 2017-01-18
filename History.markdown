## HEAD
## Major Enhancements
 * Abbility to add custom stopwords at classifier initialization ([#129](https://github.com/jekyll/classifier-reborn/pull/129))
 * Don't train/untrain the Bayesian classifier with empty word hashes ([#132](https://github.com/jekyll/classifier-reborn/pull/132))
 * Enable auto categorization if no initial categories ([#128](https://github.com/jekyll/classifier-reborn/pull/128))
 * Bayes integration test of Memory and Redis backends with real data ([#92](https://github.com/jekyll/classifier-reborn/pull/92))
 * Memory and Redis backend support ([#84](https://github.com/jekyll/classifier-reborn/pull/84))

### Minor Enhancements
 * Return the status of the training/untraining when run ([#137](https://github.com/jekyll/classifier-reborn/pull/137))
 * Refactoring of backend tests to move duplicate login in the common file ([#134](https://github.com/jekyll/classifier-reborn/pull/134))
 * Deal with Infinity score in test ([#133](https://github.com/jekyll/classifier-reborn/pull/133))
 * README file cleaned up to point to the documentation site ([#121](https://github.com/jekyll/classifier-reborn/pull/121))
 * Added and corrected RDoc for ceratin classes and methods ([#122](https://github.com/jekyll/classifier-reborn/pull/122))
 * Added favicon link and forced display ([#120](https://github.com/jekyll/classifier-reborn/pull/120))
 * Updated the truncated LICENSE file ([#116](https://github.com/jekyll/classifier-reborn/pull/116)) 
 * Docs visual improvement and refactoring ([#119](https://github.com/jekyll/classifier-reborn/pull/119)) 
 * Fixed relative URL issue on nav links and added benchmark data ([#118](https://github.com/jekyll/classifier-reborn/pull/118)) 
 * Added custom layout with navigation ([#117](https://github.com/jekyll/classifier-reborn/pull/117)) 
 * Created a static site for documentation ([#115](https://github.com/jekyll/classifier-reborn/pull/115)) 
 * Removed redis gem from Dockerfile as it is added in gemspec ([#113](https://github.com/jekyll/classifier-reborn/pull/113)) 
 * Speed up Docker image rebilding ([#112](https://github.com/jekyll/classifier-reborn/pull/112)) 
 * Improved Docker based development documentation ([#106](https://github.com/jekyll/classifier-reborn/pull/106))
 * Benchmark refactoring, improving efficiency, enhanced reporting ([#107](https://github.com/jekyll/classifier-reborn/pull/107))
 * Add Vietnamese stopwords ([#110](https://github.com/jekyll/classifier-reborn/pull/110))
 * Added stop words for Arabic, Bengali, Chinese, Hindi, and Russian ([#105](https://github.com/jekyll/classifier-reborn/pull/105)) 
 * Dockerfile and documentation ([#104](https://github.com/jekyll/classifier-reborn/pull/104))
 * Remove hard dep on Redis and update bin ([#96](https://github.com/jekyll/classifier-reborn/pull/96))
 * Documented Redis backend performance ([#103](https://github.com/jekyll/classifier-reborn/pull/103))
 * Rename Bayes memory test class ([#102](https://github.com/jekyll/classifier-reborn/pull/102))
 * Added Bayes backend benchmarks ([#98](https://github.com/jekyll/classifier-reborn/pull/98))
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
