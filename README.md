DuckDuckGo ZeroClickInfo Goodies
=================================

About
-----

See [the contribution page](https://github.com/duckduckgo/duckduckgo/wiki) for a general overview on contributing to DuckDuckGo.

This repository is for contributing goodies, which are special tools that reveal instant answers at the top of search results, e.g. calculations or throwing dice.

Most of the existing goodies are listed on the [goodies page](http://duckduckgo.com/goodies.html) and [tech goodies page](http://duckduckgo.com/tech.html).

We also maintain a list of [requested goodies](https://github.com/duckduckgo/duckduckgo/wiki/Goodies), but whatever you want to attempt is welcome.


Contributing
------------

Thank you!

Each goodie has its own directory. Some of the directories are in use on the live system, and some are still in development.

Each directory has a Perl script in it called goodie.pl, which is a working example of that goodie that can be directly inserted into the live system.

Within the goodie file, a few things are happening, and here is an overview that references live examples, which you can review:


1) There are some variables that are used in the system that operate outside the goodie, but which the goodie uses. Every goodie will use:

```perl

# This is the instant answer that gets printed out.
my $answer_results = '';

# This is a name (lowercase, no spaces) that gets 
# passed through to the API that should be defined 
# if $answer_results is set.
my $answer_type = '';

# This is defined external to the goodie and tells you 
# whether there is other Zero-click info, and if so, 
# what type is it (C for category page, etc.).
my $type = '';
```

In addition, you may want to use:

```perl

# This is used to indicate whether the results get cached or not. 
# If the goodie is supposed to provide some kind of random output 
# that changes per page view, then you will want to set this to 0.
my $is_memcached = 1;

```

Finally, you will want to use a form of the query:

```perl

# This is the most common form in use. 
# It is a lower case version of the query 
# with an initial ! and ending ? removed.
my $q_check_lc = 'example query';

# This is the raw query.
my $q = 'Example query';

# This is a lower case version of the query 
# with sanitized spaces and special characters removed.
my $q_internal = 'example query';
```

The external variables used in the goodie get defined at the top of the script. See [dice](https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/dice/goodie.pl) for a good example.

```perl
my $q_check_lc = 'roll 5 dice';

my $answer_results = '';
my $answer_type = '';
my $type = '';
my $is_memcached = 1;
```


2) The goodie needs to know when to be called. This involves some kind of conditional statement that first involves the $type variable.

```perl

# If there is no 0-click.
if (!$type) {

}


# If there is no other goodie. 
# Will kill other 0-click info, e.g. Wikipedia. 
if ($type ne 'E') {

}

```

Secondly you want to segment the query space to queries related to that goodie. [guid](https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/guid/goodie.pl) uses a hash to do so.

```perl

# Uses a hash to segment the query space.
my %guid = (
    'guid' => 0,
    'uuid' => 1,
    'globally unique identifier' => 0,
    'universally unique identifier' => 1,
    'rfc 4122' => 0,
    );

if ($type ne 'E' && exists $guid{$q_check_lc}) {

}
```

[binary](https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/binary/goodie.pl) uses a regular expression.

```perl

if (!$type && $q_check_lc =~ m/^binary (.*)$/i) {

}
```

For regular expressions, we need to watch out for false positives and speed.


3) Once inside the conditional, the goodie formulates the answer. This could vary slightly depending on input, but results in setting the $answer_results variable. Here's what [abc](https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/abc/abc.pl) looks like.

```perl
if (!$type && $q_check =~ m/^\!?\s*[A-Za-z]+(\s+or\s+[A-Za-z]+)+\s*$/ ) {
    my @choices = split(/\s+or\s+/, $q_check);
    my $choice = int(rand(@choices));

    $answer_results = $choices[$choice];
    $answer_results .= ' (random)';
    $answer_type = 'rand';
}
```


And here are some other things to keep in mind:

4) If you need a helper file, name it goodie.txt or goodie.html as needed. If you need to read in that file to be used over and over again, do it outside the conditional. For example [passphrase](https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/passphrase/goodie.pl) reads in a list at the top.

```perl
my %passphrase = ();
open(IN, '<goodie.txt');
while (my $line = <IN>) {
    chomp($line);
    my @res = split(/ /, $line);
    $passphrase{$res[0]} = $res[1];
    
}
close(IN);
```

Whereas if you need to read in a file for output, do it inside the conditional. For example, [public_dns](https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/public_dns/goodie.pl) reads in a list inside.

```perl
    open(IN,"<goodie.html");
    while (my $line = <IN>) {
    $answer_results .= $line;
    }
    close(IN);
```


5) If it is possible that the conditional gets called, but $answer_results still may not be set, then wrap $answer_type (and possibly other variables) in a separate conditional like in [private_network](https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/private_network/goodie.pl).

```perl
    if ($answer_results) {
       $answer_type = 'network';
       $type = 'E';
    }
```


