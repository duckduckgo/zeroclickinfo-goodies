package DDG::Goodie::PhoneAlphabet;
# ABSTRACT: Taking a phone number with letters in it and returning the phone number

use strict;
use POSIX;
use DDG::Goodie;

zci answer_type => 'phone_alphabet';
zci is_cached   => 1;

triggers any => 'to digit', 'to digits', 'to phone', 'to phone number', 'to numbers';

handle remainder => sub {
    my $input = shift;

    # Return unless it looks like a phone number
    return unless ($input =~ /[-0-9A-Za-z]{6,15}$/);
    # Return if it's a Hex number
    return if ($input =~ /^0x\d+$/);
    # Lower case everything.
    my $num = lc $input;
    # Use a regex to replace each letter with the corresponding number from the phone key pad.
    $num =~ tr/abcdefghijklmnopqrstuvwxyz/22233344455566677778889999/;

    return "Phone Number: $num", structured_answer => {
        data => {
            title => $num,
            subtitle => "Phone Number: $input"
        },
        templates => {
            group => 'text'
        }
    };
};

1;
