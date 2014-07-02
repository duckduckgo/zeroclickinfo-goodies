package DDG::Goodie::Mailto;
# ABSTRACT: supplies mailto: link

use DDG::Goodie;
use HTML::Entities;

name "Mailto link";
description "Provide a link to compose an email";
primary_example_queries 'mail press@duckduckgo.com', 'mail kappa@yandex.com';
category "computing_tools";
topics "everyday", "social";
code_url "https://github.com/kappa/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Mailto.pm";
attribution github => "kappa", cpan => "kappa", email => 'alex@kapranoff.ru';

zci is_cached => 1;

triggers start => 'mail';

handle remainder => sub {
    # the crudest email regexp ever to weed out obvious non-emails
    # there's no need to bring in huge Email::Valid
    return unless $_ && m/.@[^.]*\.[^.]/;

    # html_enc() encodes anything non-ASCII and has some non-obvious
    # list context issues, so use encode_entities directly
    my $escaped = encode_entities($_, q{<>"'&});

    return $_,
        html => qq{Click to email <a href="mailto:$escaped">$escaped</a>};
};

1;
