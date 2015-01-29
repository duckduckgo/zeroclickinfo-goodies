package DDG::Goodie::PhoneAlphabet;
# ABSTRACT: Taking a phone number with letters in it and returning the phone number

use POSIX;
use DDG::Goodie;

zci answer_type => 'phone_alphabet';
zci is_cached   => 1;

name "PhoneAlphabet";
description "Returns the phone number from a word phone number";
primary_example_queries "1-800-FUN-HACK to digits", "1-800-LAWYR-UP to phone number";
category 'reference';
topics 'special_interest';
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/PhoneAlphabet.pm";
attribution github => ["https://github.com/stevelippert", "Steve Lippert"],
            twitter => ["https://twitter.com/stevelippert", "stevelippert"];

triggers any => 'to digit', 'to digits', 'to phone', 'to phone number';

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

    return "Phone Number: $num",
    structured_answer => {
        input     => [html_enc($input)],
        operation => "Phone Number",
        result    => "$num",
    };
};

1;
