package DDG::GoodieRole::WhatIs;
# ABSTRACT: Role for query matching.

use strict;
use warnings;

use Moo::Role;
use DDG::GoodieRole::WhatIsBase;

# Use for translations between systems where it makes sense to say
# 'What is X in Y?'.
sub wi_translation {
    my $got_options = shift;
    my $groups = ['translation'];
    push $groups, @{$got_options->{groups}} if defined $got_options->{groups};
    my $presets = {
        groups => $groups,
    };
    my %options = (%$got_options, %$presets);
    return DDG::GoodieRole::WhatIsBase->new(\%options);
}

1;
