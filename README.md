DuckDuckGo ZeroClickInfo Goodies
=================================

About
-----

See https://github.com/duckduckgo/duckduckgo/wiki for a general overview on contributing to DuckDuckGo.

This repository is for contributing goodies, special tools that reveal instant answers, e.g. calculations or throwing dice.


Contributing
------------

This repository is organized by type of content, each with its own directory. Some of those projects are in use on the live system, and some are still in development.

Each directory has a Perl script called goodie.pl, which is an example of that goodie.

See the guid directory for a working example. Within the file, a few things are happening, and you can look at the comments in that example for details. But here is an overview:

1) The goodie needs to know when to be called. In the example, this is done via a keyword hash, but could also easily be a regular expression. If it is the latter, we need to watch out for false positives and speed.

2) Once called, it formulates the answer. This could vary slightly depending on input. 

3) The answer_results and answer_type variables are set.

