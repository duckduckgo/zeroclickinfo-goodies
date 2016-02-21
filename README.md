# Sage Examples

[![Build Status](https://travis-ci.org/duckduckgo/zeroclickinfo-goodies.png?branch=master)](https://travis-ci.org/duckduckgo/zeroclickinfo-goodies)

Examples of what 'Sage' Instant Answers *might* look like.

## What is a Sage?

Sage is an idea for a new type of Instant Answer I've had that allows many
people to contribute to DuckDuckHack in niche areas without needing much -
if any - programming experience.

A Sage Instant Answer would consist of two parts:

1. The Controller: the Controller would represent the *type* and *use* of
the particular Instant Answer. The Controller determines how to read,
interpret, and display the Answer Files - the `CheatSheets.pm` file, along
with helper files is a prime example of a Controller.

2. Answer Files: each Answer File represents a particular unit that is
interpreted by the controller; for example, the `vim.json` cheat sheet
would be an Answer File for the CheatSheets Controller.

### Rationale

Cheat sheets, currently embedded in the `Goodies` repository, are very
useful! But the amount of cheat sheets that come in compared to Perl-driven
Goodies is rather high - making it harder to spend time reviewing and
progressing Perl-backed Goodies.

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
