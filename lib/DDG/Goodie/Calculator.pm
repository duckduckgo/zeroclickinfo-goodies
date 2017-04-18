package DDG::Goodie::Calculator;
# ABSTRACT: handles the triggering for the calculator

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::NumberStyler';

use utf8;

zci answer_type => 'calc';
zci is_cached   => 1;

my $calc_regex = qr/^(free)?(online)?calc(ulator)?(online)?(free)?$/;
triggers query_nowhitespace => $calc_regex;

triggers query_nowhitespace => qr'^
    (?: [0-9 () x × ∙ ⋅ * % + \- ÷ / \^ \$ \. \, _ =]+ |
    what is| calculat(e|or) | solve | math |
    times | divided by | plus | minus | fact | factorial | cos |
    sin | tan | cotan | log | ln | log_?\d{1,3} | exp | tanh |
    sec | csc | squared | sqrt | gross | dozen | pi | e |
    score){2,}$
'xi;

my $funcy     = qr/[[a-z]+\(|log[_]?\d{1,3}\(|\^|\*|\/|squared|divided/;    # Stuff that looks like functions.

my $ip4_octet = qr/([01]?\d\d?|2[0-4]\d|25[0-5])/;                          # Each octet should look like a number between 0 and 255.
my $ip4_regex = qr/(?:$ip4_octet\.){3}$ip4_octet/;                          # There should be 4 of them separated by 3 dots.
my $up_to_32  = qr/([1-2]?[0-9]{1}|3[1-2])/;                                # 0-32
my $network   = qr#^$ip4_regex\s*/\s*(?:$up_to_32|$ip4_regex)\s*$#;         # Looks like network notation, either CIDR or subnet mask

#separates symbols with a space
#spacing '1+1'  ->  '1 + 1'
sub spacing {
    my ($text, $space_for_parse) = @_;

    $text =~ s/\s{2,}/ /g;
    $text =~ s/(\s*(?<!<)(?:[\+\^xX×∙⋅\*\/÷\%]|(?<!\de)\-|times|plus|minus|dividedby)+\s*)/ $1 /ig;
    $text =~ s/\s*dividedby\s*/ divided by /ig;
    $text =~ s/(\d+?)((?:dozen|pi|gross|squared|score))/$1 $2/ig;
    $text =~ s/([\(\)])/ $1 /g if $space_for_parse;

    return $text;
}

handle query_nowhitespace => sub {
    my $query = $_;

    if ($query =~ $calc_regex) {
        return '', structured_answer => {
            data => {
                title_html => '0'
            },
            templates => {
                group => 'base',
                options => {
                    content => 'DDH.calculator.content'
                }
            }
        };
    }

    return if $req->query_lc =~ /^0x/i; # hex maybe?
    return if ($query =~ $network);     # Probably want to talk about addresses, not calculations.
    return if ($query =~ qr/(?:(?<pcnt>\d+)%(?<op>(\+|\-|\*|\/))(?<num>\d+)) | (?:(?<num>\d+)(?<op>(\+|\-|\*|\/))(?<pcnt>\d+)%)/);    # Probably want to calculate a percent ( will be used PercentOf )
    return if ($query =~ /^(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:\(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?$/); # Probably are searching for a phone number, not making a calculation
    return if $query =~ m{[x × ∙ ⋅ * % + \- ÷ / \^ \$ \. ,]{3,}}i;
    return if $query =~ /\$[^\d\.]/;
    return if $query =~ /\(\)/;

    $query =~ s/^(?:whatis|calculat(e|or)|solve|math)//i;
    return if $query =~ /^(?:minus|-)\d+$/;
    $query = spacing($query, 1);
    
    return '', structured_answer => {
        data => {
            title_html => "$query"
        },
        templates => {
            group => 'base',
            options => {
                content => 'DDH.calculator.content'
            }
        }
    };

};

1;
