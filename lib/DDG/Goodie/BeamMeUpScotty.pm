package DDG::Goodie::BeamMeUpScotty;
# ABSTRACT: A Star Trek catchphrase

use DDG::Goodie;
use strict;

zci answer_type => 'beam_me_up_scotty';
zci is_cached => 1;

triggers start => 'beam me up scotty', 'beam us up scotty';

handle remainder => sub {
    return unless ($_ eq '');

    my $answer = 'Aye, aye, captain.';

    return $answer,
      structured_answer => {
        input     => ['Beam me up, Scotty'],
        operation => 'Code phrase',
        result    => $answer
      };
};

1;
