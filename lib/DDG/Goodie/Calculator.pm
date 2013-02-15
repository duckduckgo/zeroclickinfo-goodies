package DDG::Goodie::Calculator;

use DDG::Goodie;

zci is_cached => 1;
zci answer_type => "calculator";

triggers query_nowhitespace => qr/^!?[\(\)xX\*\%\+\-\/\^\$]*(?:[0-9\.\,]+|[0-9\.\,]*)(?:gross|dozen|pi|(e)|c|)(?(1)(?:-?[0-9\.\,]+|)|)(?:[\(\)xX\*\%\+\-\/\^\$]|times|dividedby|plus|minus)+(?:[0-9\.\,]+|[0-9\.\,]*)(?:gross|dozen|pi|e|c|)[\(\)xX\*\%\+\-\/\^0-9\.\,\$]*=?$/i; 

handle query_nowhitespace => sub {
    sub commify {
        my $text = reverse $_[0];
        $text =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
        return scalar reverse $text;
    }

    my $results;
    my ($query) = @_;
    if($query !~ /[xX]\s*[\*\%\+\-\/\^]/ && $query !~ /^-?[\d]{2,3}\.\d+,\s?-?[\d]{2,3}\.\d+$/) {
        my $tmp_result = '';

        # Grab expression.
        my $tmp_expr = $query;

        $tmp_expr =~ s/\^/**/g;
        $tmp_expr =~ s/(?:x|times)/*/ig;
        $tmp_expr =~ s/minus/-/ig;
        $tmp_expr =~ s/plus/+/ig;
        $tmp_expr =~ s/dividedby/\//ig;

        # sub in constants
        # e sub is lowercase only because E == *10^n
        $tmp_expr =~ s/((?:\d+?|\s))E(-?\d+)([^\d])/\($1 * 10**$2\)$3/g;
        $tmp_expr =~ s/(\d+?)e([^A-Za-z])/$1 * 2.71828182845904523536028747135266249 $2/g;
        $tmp_expr =~ s/([^A-Za-z])e([^A-Za-z])/$1 2.71828182845904523536028747135266249 $2/g;
        $tmp_expr =~ s/\be\b/2.71828182845904523536028747135266249/g;
        $tmp_expr =~ s/(\d+?)c([^A-Za-z])/$1 * 299792458 $2/ig;
        $tmp_expr =~ s/([^A-Za-z])c([^A-Za-z])/$1 299792458 $2/ig;
        $tmp_expr =~ s/\bc\b/299792458/ig;
        $tmp_expr =~ s/(\d+?)pi/$1 * 3.14159265358979323846264338327950288/ig;
        $tmp_expr =~ s/pi/3.14159265358979323846264338327950288/ig;
        $tmp_expr =~ s/(\d+?)gross/$1 * 144/ig;
        $tmp_expr =~ s/(\d+?)dozen/$1 * 12/ig;
        $tmp_expr =~ s/dozen/12/ig;
        $tmp_expr =~ s/gross/144/ig;

        # Commas into periods.
        $tmp_expr =~ s/(\d+),(\d{1,2})(?!\d)/$1.$2/g;

        # Drop commas.
        $tmp_expr =~ s/[\,\$]//g;

        # Drop =.
        $tmp_expr =~ s/=$//;

        # Drop leading 0s.
        # 2011.11.09 fix for 21 + 15 x 0 + 5
        $tmp_expr =~ s/(?<!\.)(?<![0-9])0([1-9])/$1/;

        eval {
            $tmp_result = eval($tmp_expr);
        };

        # 0-9 check for http://yegg.duckduckgo.com/?q=%243.43%20%2434.45&format=json
        if ($tmp_result && $tmp_result ne 'inf' && $tmp_result =~ /^(?:\-|)[0-9\.]+$/) {
            # Precisian.
            my $precisian = 0;

            # too clever -- .5 ^ 2 not working right.
            if (0) {
                while ($query =~ /\.(\d+)/g) {
                    my $decimal = length($1);
                    $precisian = $decimal if $decimal > $precisian;
                }

                $tmp_result = sprintf( '%0.' . $precisian . 'f', $tmp_result ) if $precisian;
            }
        
            # Dollars.
            if ($query =~ /^\$/) {
                $tmp_result = qq(\$$tmp_result);
            }

            # Query for display.
            my $tmp_q = $query;

            # Drop equals.
            $tmp_q =~ s/\=$//;

            $tmp_q =~ s/((?:\d+?|\s))E(-?\d+)/\($1 * 10^$2\)/;

            # Superscript (before spacing).
            #$tmp_q =~ s/\^\(([^\)]+)\)/<sup>$1<\/sup>/g unless $data->{no_html};
            #$tmp_q =~ s/\^(\d+|\b(?:e|c)\b)/<sup>$1<\/sup>/g unless $data->{no_html};

            # Add spacing.
            $tmp_q =~ s/(\s*(?<!<)(?:[\+\-\^xX\*\/\%]|times|plus|minus|dividedby)+\s*)/ $1 /ig;
            $tmp_q =~ s/dividedby/divided by/ig;
            $tmp_q =~ s/(\d+?)((?:dozen|pi|gross|e|c))/$1 $2/ig;
            $tmp_q =~ s/\bc\b/speed of light/ig;
    
            # Add commas.
            $tmp_result = &commify($tmp_result);

            # Now add it back.
            $tmp_q .= ' = ';

            # Add as first result (up to this point).
            #   unshift(@results_main,qq($tmp_q<a href="javascript:;" onClick="document.x.q.value='$tmp_result'">$tmp_result</a>));
            $results = qq(<div>$tmp_q<a href="javascript:;" onClick="document.x.q.value='$tmp_result';document.x.q.focus();">$tmp_result</a></div>);
            return html => $results;
        }
    }

    return;
};

1;