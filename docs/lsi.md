---
layout: default
---

# Latent Semantic Indexer (LSI)

Latent Semantic Indexing engines are not as fast or as small as Bayesian classifiers, but are more flexible, providing fast search, and clustering detection as well as semantic analysis of the text that
theoretically simulates human learning.

## Usage

```ruby
require 'classifier-reborn'
lsi = ClassifierReborn::LSI.new
strings = [["This text deals with dogs. Dogs.", :dog],
           ["This text involves dogs too. Dogs! ", :dog],
           ["This text revolves around cats. Cats.", :cat],
           ["This text also involves cats. Cats!", :cat],
           ["This text involves birds. Birds.",:bird ]]
strings.each {|x| lsi.add_item x.first, x.last}

lsi.search("dog", 3)
#=> ["This text deals with dogs. Dogs.",
#    "This text involves dogs too. Dogs!",
#    "This text also involves cats. Cats!"]

lsi.find_related(strings[2], 2)
#=> ["This text revolves around cats. Cats.",
#    "This text also involves cats. Cats!"]

lsi.classify "This text is also about dogs!"
#=> :dog
```

Please see the [ClassifierReborn::LSI documentation](http://www.rubydoc.info/gems/classifier-reborn/ClassifierReborn/LSI) for more information.
It is possible to index, search and classify with more than just simple strings.

**Note:** *A Redis backend is not implemented for LSI yet.*

## References

* [Latent Semantic Indexing](http://www.c2.com/cgi/wiki?LatentSemanticIndexing)
* [Smart Bookmarking](http://web.archive.org/web/20061126153713/http://www.chadfowler.com/index.cgi/Computing/LatentSemanticIndexing.rdoc)
* [Latent semantic analysis](http://en.wikipedia.org/wiki/Latent_semantic_analysis)
