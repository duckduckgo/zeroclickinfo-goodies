DuckDuckHack Goodies
====
This documentation walks you through the process of writing a DuckDuckHack Goodie plugin.
Before reading this section, make sure you've read the [DuckDuckHack Intro Site](http://duckduckhack.com) and the [DuckDuckHack Developer's Overview](https://github.com/duckduckgo/duckduckgo/blob/master/README.md) (so you know what we're talking about).

## Basic Tutorial

In this tutorial, we'll be making a Goodie plugin that checks the number of characters in a given search query. The end result will look [like this](https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Chars.pm) and works [like this](https://duckduckgo.com/?q=chars+How+many+characters+are+in+this+sentence%3F). The same framework is used to trigger Spice plugins.

Let's begin. Open a text editor like [gedit](http://projects.gnome.org/gedit/), notepad or [emacs](http://www.gnu.org/software/emacs/) and type the following:

```perl
package DDG::Goodie::Chars;
# ABSTRACT: Give the number of characters (length) of the query.
```

Each plugin is a [Perl package](https://duckduckgo.com/?q=perl+package), so we start by declaring the package namespace. In a new plugin, you would change **Chars** to the name of the new plugin (written in [CamelCase](https://duckduckgo.com/?q=camelcase) format).

The second line is a special comment line that gets parsed automatically to make nice documentation (by [Dist::Zilla](https://metacpan.org/module/Dist::Zilla)).

Next, type the following [use statement](https://duckduckgo.com/?q=perl+use) to import [the magic behind](https://github.com/duckduckgo/duckduckgo/tree/master/lib/DDG) our plugin system.

```perl
use DDG::Goodie;
```

Now here's where it gets interesting. Type:

```perl
triggers start => 'chars';
```

**triggers** are keywords that tell us when to make the plugin run. They are _trigger words_. When a particular trigger word is part of a search query, it tells DuckDuckGo to _trigger_ the appropriate plugins.

In this case there is one trigger word: **chars**. Let's say someone searched "chars this is a test." **chars** is the first word so it would trigger our Goodie. The **start** keyword says, "Make sure the trigger word is at the start of the query." The **=>** symbol is there to separate the trigger words from the keywords (for readability).

Now type in this line:

```perl
handle remainder => sub {
```

Once triggers are specified, we define how to _handle_ the query. **handle** is another keyword, similar to triggers.

You can _handle_ different aspects of the search query, but the most common is the **remainder**, which refers to the rest of the query (everything but the triggers). For example, if the query was _"chars this is a test"_, the trigger would be _chars_ and the remainder would be _this is a test_.

Now let's add a few more lines to complete the handle function.

```perl
handle remainder => sub {
    return 'Chars: ' . length $_ if $_;
    return;
};
```

This function (the part within the **{}** after **sub**) is the meat of the Goodie. It generates the instant answer that is displayed at the top of the [search results page](https://duckduckgo.com/?q=chars+this+is+a+test).

Whatever you are handling is passed to the function in the **$_** variable ( **$_** is a special default variable in Perl that is commonly used to store temporary values). For example, if you searched DuckDuckGo for _"chars this is a test"_, the value of **$_** will be _"this is a test"_, i.e. the remainder.

Let's take a closer look at the first line of the function.

```perl
return 'Chars: ' . length $_ if $_;
```

The heart of the function is just this one line. The **remainder** is in the **$_** variable as discussed. If it is not blank ( **if $_** ), we return the number of chars using Perl's built-in [length function](https://duckduckgo.com/?q=perl+length).

Perl has a lot of built-in functions, as well as thousands and thousands of modules available [via CPAN](https://metacpan.org/). You can leverage these modules when making Goodies, similar to how the [Roman Goodie](https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Roman.pm) uses the [Roman module](https://metacpan.org/module/Roman).

If we are unable to provide a good instant answer, we simply **return** nothing. And that's exactly what the second line in the function does.

```perl
return;
```

This line is only run if **$_** contained nothing, because otherwise the line before it would return something and end the function.

Now, below your function type the following line:

```perl
zci is_cached => 1;
```

This line is optional. Goodies technically return a [ZeroClickInfo object](https://metacpan.org/module/WWW::DuckDuckGo::ZeroClickInfo) (abbreviated as **zci**). This effect happens transparently by default, but you can override this default behavior via the **zci** keyword.

We set **is_cached** to true (0 is false, 1 is true) because this plugin will always return the same answer for the same query. This speeds up future answers by caching them (saving previous answers).

Finally, all Perl packages that load correctly should [return a true value](http://stackoverflow.com/questions/5293246/why-the-1-at-the-end-of-each-perl-package) so add a 1 on the very last line.

```perl
1;
```

And that's it! At this point you have a working DuckDuckHack Goodie plugin. It should look like this:

```perl
package DDG::Goodie::Chars;
# ABSTRACT: Give the number of characters (length) of the query.

use DDG::Goodie;

triggers start => 'chars';

handle remainder => sub {
    return 'Chars: ' . length $_ if $_;
    return;
};

zci is_cached => 1;

1;
```
### Review
The plugin system works like this at the highest level:

* We break the query (search terms) into words. This process happens in the background.

* We see if any of those words are **triggers** (trigger words). These are provided by each of the plugins. In the example, the trigger word is **chars**.

* If a Goodie plugin is triggered, we run its **handle** function.

* If the Goodie's handle function outputs an instant answer via a **return** statement, we pass it back to the user.

### Where to go from here

#### If you're planning on writing a Goodie plugin:
Before heading to the sections below, jump on over to the page that covers [testing triggers](https://github.com/duckduckgo/duckduckgo/blob/master/README.md#testing-triggers). See you back here soon!

#### "I came here to write Spice!": 

Cool! You're done the basic tutorial. Now check out the section on [Spice handle functions](http://duckduckhack.com/#spice-handle-functions) in the zeroclickinfo-spice repository.

## Advanced Triggers
In the [Basic tutorial](README.md#basic-tutorial) we walked through a one word trigger and in the [Spice handle functions](http://duckduckhack.com/#spice-handle-functions) section we walked through a simple regexp trigger.

Here are some more advanced trigger techniques you may need to use:

**Multiple trigger words**. &nbsp;Suppose you thought that in addition to _chars_, _numchars_ should also trigger the [Chars Goodie](https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Chars.pm). You can simply add extra trigger words to the triggers definition.

```perl
triggers start => 'chars', 'numchars';
```

**Trigger locations.** &nbsp;The keyword after triggers, **start** in the Chars example, specifies where the triggers need to appear. Here are the choices:

 * start - just at the start of the query
 * end - just at the end of the query
 * startend - at either end of the query
 * any - anywhere in the query

**Combining locations.** &nbsp;You can use multiple locations like in the [Drinks Spice](https://github.com/duckduckgo/zeroclickinfo-spice/blob/master/lib/DDG/Spice/Drinks.pm).

```perl
triggers any => "drink", "make", "mix", "recipe", "ingredients";
triggers start => "mixing", "making";
```

**Regular Expressions.** &nbsp;As we walked through in the [Spice handle functions](http://duckduckhack.com/#spice-handle-functions) section you can also trigger on a regular expression.

```perl
triggers query_lc => qr/^@([^\s]+)$/;
```

We much prefer you use trigger words when possible because they are faster on the backend. However, in some cases regular expressions are necessary, e.g. when you need to trigger on sub-words.

**Regexp types.** &nbsp;Like trigger words, regular expression triggers have several keywords as well. In the above example **query_lc** was used, which operates on the lower case version of the full query. Here are the choices:

 * **query_raw** - the actual (full) query
 * **query** - with extra whitespace removed
 * **query_lc** - lower case version of the query and extra whitespace removed
 * **query_clean** - lower case with non alphanumeric ASCII and extra whitespace removed
 * **query_nowhitespace** - with whitespace totally removed
 * **query_nowhitespace_nodash** - with whitespace and dashes totally removed

If you want to see some test cases where these types are enumerated check out our [internal test file](https://github.com/duckduckgo/duckduckgo/blob/master/t/15-request.t) that tests they are generated properly.

**Two-word+ triggers** &nbsp;Right now trigger words only operate on single words. If you want to operate on a two or more word trigger, you have a couple of options.

 * Use a regular expression trigger like in the [Expatistan Spice](https://github.com/duckduckgo/zeroclickinfo-spice/blob/master/lib/DDG/Spice/Expatistan.pm).

```perl
triggers query_lc => qr/cost of living/;
```

 * Use single word queries and then further qualify the query within the handle function as explained in the [Advanced handle functions](#advanced-handle-functions) section.

## Advanced Handle Functions

In the [Basic tutorial](README.md#basic-tutorial) we walked through a simple query transformation and in the [Spice handle functions](http://duckduckhack.com/#spice-handle-function) section we walked through a simple return of the query.

Here are some more advanced handle techniques you may need to use:

**Further qualifying the query.** &nbsp;Trigger words are blunt instruments; they may send you queries you cannot handle. As such, you generally need to further qualify the query (and return nothing in cases where the query doesn't really qualify for your goodie).

There are number of techniques for doing so. For example, the first line of [Base Goodie](https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Base.pm) has a return statement paired with unless.

```perl
return unless  /^([0-9]+)\s*(?:(?:in|as)\s+)?(hex|hexadecimal|octal|oct|binary|base\s*([0-9]+))$/;
```

You could also do it the other way, like the [GoldenRatio Goodie](https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/GoldenRatio.pm).

```perl
if ($input =~ /^(?:(?:(\?)\s*:\s*(\d+(?:\.\d+)?))|(?:(\d+(?:\.\d+)?)\s*:\s*(\?)))$/) {
```

Another technique is to use a hash to allow specific query strings, as the [GUID Goodie](https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/GUID.pm) does.

```
my %guid = (
    'guid' => 0,
    'uuid' => 1,
    'globally unique identifier' => 0,
    'universally unique identifier' => 1,
    'rfc 4122' => 0,
    );

return unless exists $guid{$_};
```

**Handling the whole query.** &nbsp;In the Chars example, we handled the **remainder**. You can also handle:

* **query_raw** - the actual (full) query
* **query** - with extra whitespace removed
* **query_parts** - like query but given as an array of words
* **query_nowhitespace** - with whitespace totally removed
* **query_nowhitespace_nodash** - with whitespace and dashes totally removed

For example, the [Xor Goodie](https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Xor.pm) handles query_raw and the [ABC Goodie](https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/ABC.pm) handles query_parts.

**Using files**. &nbsp;You can use simple text/html input files for display or processing.

```perl
my @words = share('words.txt')->slurp;
```

The [Passphrase Goodie](https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Passphrase.pm) does this for processing purposes and the [PrivateNetwork Goodie](https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/PrivateNetwork.pm) does it for display purposes.

The files themselves go in the **/share/goodie/** directory.

**Generating data files.** You may also need to generate data files. If you do so, please also include the generation scripts. These do not have to be done in Perl, and you can also put them within the **/share/goodie/** directory. For example, the [CurrencyIn Goodie](https://github.com/duckduckgo/zeroclickinfo-goodies/tree/master/share/goodie/currency_in) uses a Python script to generate the input data.


There are a couple more sections on advanced handle techniques depending on [Plugin type](https://github.com/duckduckgo/duckduckgo/blob/master/README.md#overview):

* For **Goodies**, check out the [Advanced Goodies](#advanced-goodies) section.
* For **Spice**, check out the [Advanced Spice handlers](http://duckduckhack.com/#advanced-spice-handlers) section.

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
