package DDG::GoodieRole::WhatIs;
# ABSTRACT: Role for working with translations between various systems.

use strict;
use warnings;

use Hash::Merge qw(merge);
use Moo::Role;
use DDG::GoodieRole::WhatIsBase;

# Use for translations between systems where it makes sense to say
# 'What is X in Y?'.
sub wi_translation {
    my $got_options = shift;
    my $presets = {
        type => 'translation',
    };
    my %options = %{ merge($got_options, $presets) };
    return DDG::GoodieRole::WhatIsBase->new(\%options);
}


1;
