DuckDuckHack Goodies
====
This documentation walks you through the process of writing a DuckDuckHack Goodie plugin.
Before reading this section, make sure you've read the [DuckDuckHack Intro Site](http://duckduckhack.com) and the [DuckDuckHack Developer's Overview](https://github.com/duckduckgo/duckduckgo/blob/master/README.md). If you're here to brush up on Goodie info, scroll down. If you're here to learn how to write Goodie Plugins, check out the [Goodies Overview](https://github.com/duckduckgo/duckduckgo#goodies-overview).

### Example
![morse code example](https://s3.amazonaws.com/ddg-assets/docs/goodie_example.png)

## Writing test files

Every goodie includes a test file in the `t` directory. For example, the **RouterPasswords** goodie uses the the test file `t/RouterPasswords.t`. This test file includes sample queries and answers, and is run automatically before every release to ensure that all goodies are triggering properly with correct answers. The test file is a Perl program that uses the Perl packages `DDG::Test::Goodie` and `Test::More` to function. Here's an annotated excerpt from `t/RouterPasswords.t` that you can use as a base:

```perl
#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

# These zci attributes aren't necessary, but if you specify them inside your goodie,
# you'll need to add matching values here to check against.
zci answer_type => 'password';
zci is_cached => 1;

ddg_goodie_test(
	[
        # This is the name of the goodie that will be loaded to test.
		'DDG::Goodie::RouterPasswords'
    ],
    # This is a sample query, just like the user will enter into the DuckDuckGo search box
	'Belkin f5d6130' =>
        test_zci(
            # The first argument to test_zci is the plain text (default) returned from a goodie.
            # If your goodie also returns an HTML version, you can pass that along explicitly as
            # the second argument. If your goodie is random, you can use regexs instead of
            # strings to match against.
            'Default login for the BELKIN F5D6130: Username: (none) Password: password',
            html => 'Default login for the BELKIN F5D6130:<br><i>Username</i>: (none)<br><i>Password</i>: password'
        ),
    # You should include more test cases here. Try to think of ways that your plugin
    # might break, and add them here to ensure they won't.
);

done_testing;
```

Once you've written a test file, you can test it on it's own with `perl -Ilib t/GoodieName.t`.

## Advanced Goodies
These advanced handle techniques are specific to Goodie plugins:

**Returning HTML**. &nbsp;Goodies return text instant answers by default, but can return simple HTML as well. In that case, simply attach the html version to the end of the return statement.

```perl
return $text, html => $html;
```

**Other zci keywords**. &nbsp;The Chars example sets the **is_cached** zci keyword. You can find other settable attributes in the [object documentation](https://metacpan.org/module/WWW::DuckDuckGo::ZeroClickInfo). For example, the [GoldenRatio Goodie](https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/GoldenRatio.pm) sets the **answer_type** variable, which gets returned in the API.

```perl
zci answer_type => "golden_ratio";
```

## Location API
Sometimes, all a plugin needs is the user's location. This is where the Location API comes in. An example is the [Is it snowing?](https://github.com/duckduckgo/zeroclickinfo-spice/blob/master/lib/DDG/Spice/Snow.pm) plugin:

```perl
# Phoenixville, Pennsylvania, United States
my $location = join(", ", $loc->city, $loc->region_name, $loc->country_name);
```

When testing on `duckpan`, the plugin will always point you to "Phoenixville, Pennsylvania, United States," but don't worry, because it will show the real location once it's live.
And it isn't limited to just the city, the state, and the country, either. [Location.pm](https://github.com/duckduckgo/duckduckgo/blob/master/lib/DDG/Location.pm#L6) lists all the things that you can possibly use:

```perl
my @geo_ip_record_attrs = qw( country_code country_code3 country_name region
    region_name city postal_code latitude longitude time_zone area_code
	continent_code metro_code );
```

Sample contents of `$loc`:

```perl
longitude => -75.5385
country_name => United States
area_code => 610
region_name => Pennsylvania
country_code => US
region => PA
continent_code => NA
city => Phoenixville
postal_code => 19460
latitude => 40.1246
time_zone => America/New_York
metro_code => 504
country_code3 => USA
```
