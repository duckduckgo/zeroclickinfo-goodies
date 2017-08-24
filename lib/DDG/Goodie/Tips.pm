package DDG::Goodie::Tips;
# ABSTRACT: Calculates a tip on a bill or a general percentage

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::NumberStyler';

my @generic_trigs = ('tip calculator', 'calculate tip', 'tips calculator', 'calculate tips', 'bill tip', 'tip cost');
triggers any => @generic_trigs;
triggers any => 'tip', 'tips', 'of';

zci answer_type => 'tip';
zci is_cached   => 1;

my $number_re = number_style_regex();

handle query_lc => sub {

    # sets up the vanilla UI with default values
    # no values should be pased to the front-end
    my $query = $_;
    if(grep { $_ eq $query } @generic_trigs) {
        return '', structured_answer => {
            data => {
                title => "Tip Calculator",
                percentage => '',
                bill => '',
            },
            templates => {
                group => 'text',
                options => {
                    content => 'DDH.tips.content'
                },
            }
        };
    }

    # The following code handles more verbose and
    # complicated queries such as:
    # 
    # - 20% tip on $400 bill
    # - 14% tip for a $10 bill
    return unless (/^(?<p>$number_re)(?: ?%| percent) (?:(?<do_tip>(?<tax_or_tip>tip) (?:on|for|of))|of)(?: an?)? (?<sign>[\$\-]?)(?<num>$number_re)(?: bill)?$/);
    
    my ($p, $num) = ($+{'p'}, $+{'num'});
    my $style = number_style_for($p, $num);
    $p   = $style->for_computation($p);
    $num = $style->for_computation($num);
    
    if ($+{'do_tip'}) {
        return '', structured_answer => {
            data => {
                title => "Tip Calculator",
                percentage => "$p",
                bill => "$num",
            },
            templates => {
                group => 'text',
                options => {
                    content => 'DDH.tips.content'
                },
            },
        };
    } else {
        return;
    }
};

1;
