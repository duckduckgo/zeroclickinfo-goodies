# Sage Examples

[![Build Status](https://travis-ci.org/duckduckgo/zeroclickinfo-goodies.png?branch=master)](https://travis-ci.org/duckduckgo/zeroclickinfo-goodies)

Examples of what 'Sage' Instant Answers *might* look like.

## What is a Sage?

Sage is an idea for a new type of Instant Answer I've had that allows many
people to contribute to DuckDuckHack in niche areas without needing much -
if any - programming experience.

I call them 'Sage' because someone who is 'sage' is well-versed, wise and
specialist in a particular field - exactly what I hope Sages can cater for,
any answer which requires the input of someone wise to that field (for
example, cheat sheets are *'specialist'* knowledge).

### Rationale

Cheat sheets, currently embedded in the `Goodies` repository, are very
useful! But the amount of cheat sheets that come in compared to Perl-driven
Goodies is rather high - making it harder to spend time reviewing and
progressing Perl-backed Goodies. *Over a quarter of all Goodie PRs are
cheat sheets - that's for* ***one*** *back-end file*.

Providing a separate repository (`duckduckgo/zeroclickinfo-Sage`) for cheat
sheets, as well as other Sage formats, would provide two immediate
benefits:

1. It would allow the Goodies repository to focus more on Perl and
JavaScript driven Instant Answers.
2. It would make it a lot easier for people who don't have time to write
a fully-programmed Instant Answer to find areas in which they can
contribute.

Additional benefits may include:

* Sages could provide a means of covering a much higher percentage of
queries - through automatic trigger generation (see #2170) as well as
community contributed triggers and answers.
* Sages could open up a whole new area for Instant Answer contribution:
specialists in many different fields could contribute to Sages that deal
with walkthroughs, complex questions (for when Stack Exchange hasn't got
it covered), recommendations, and more!
* It would provide a place for community-driven, static (though I don't see
why we wouldn't be able to have dynamic!) responses to reside.

### Components

A Sage Instant Answer would consist of two parts:

1. The Controller: the Controller would represent the *type* and *use* of
the particular Instant Answer. The Controller determines how to read,
interpret, and display the Answer Files - the `CheatSheets.pm` file, along
with helper files is a prime example of a Controller.

2. Answer Files: each Answer File represents a particular unit that is
interpreted by the controller; for example, the `vim.json` cheat sheet
would be an Answer File for the CheatSheets Controller.

### Structure

The structure of a Sage Instant Answer would not be dissimilar to the
existing Instant Answer types.

* The back-end Controller file would go under `lib/DDG/Sage/CONTROLLER.pm`
* The front-end JavaScript files would go under `share/sage/SAGE_NAME/`
* The Answer Files would go under `share/sage/SAGE_NAME/answers/`

An alternative might be to have the front-end files go in another directory
parallel to `answers/`, e.g., `front_end/`.


## The Examples

Firstly, the most representative Instant Answer that would be considered
Sage is the CheatSheets Goodie. It displays quite well the vision of a
Sage I have - providing a full-featured, well-designed means of creating
sound Instant Answers with little work.

Obviously I don't have time to create examples on the scale of CheatSheets,
so the provided examples are more basic.

### The most basic - text response

This Sage (named `SageExample`) represents the most basic kind of Sage you
could have: the Controller simply accepts YAML files that specify queries
and responses.

The example Answer File
(`share/goodie/sage_example/answers/easter-eggs.yaml`) provides an example
of what an Answer File for this Sage might look like. This would already
reduce the need for some Goodies that only provide a static response to
various queries, and with a bit of work regular expression queries, as well
as other options, could be added to the Sage to provide much more power.

### Slightly more complex,  but not by much - lists of steps

This Sage (named `SageExampleSteps`) allows the specification of queries,
as well as a static list response that will be displayed on a successful
match.

The main differences between this example and the previous example are:

* It allows aliases to be specified (like `CheatSheets`)
* It provides support for a custom title
* It uses the Answer File name to produce an example query
(like `CheatSheets`)

The example Answer File
(`share/goodie/sage_example_steps/answers/how-to-get-rich.yaml`) shows a
simple example of this, as well as (apparently) satisfying a common query
(I checked!).
