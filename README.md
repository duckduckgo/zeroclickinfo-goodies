DuckDuckHack Goodies
====
This documentation walks you through the process of writing a DuckDuckHack Goodie plugin.
Before reading this section, make sure you've read the [DuckDuckHack Intro Site](http://duckduckhack.com) and the [DuckDuckHack Developer's Overview](https://github.com/duckduckgo/duckduckgo/blob/master/README.md). If you're here to brush up on Goodie info, scroll down. If you're here to learn how to write Goodie Plugins, check out the [Goodies Overview](https://github.com/duckduckgo/duckduckgo#goodies-overview).


## Advanced Goodies
These advanced handle techniques are specific to Goodie plugins:

**Returning HTML**. &nbsp;Goodies return text instant answers by default, but can return simple HTML as well. In that case, simply attach the html version to the end of the return statement.

```perl
return $text, html => $html
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
