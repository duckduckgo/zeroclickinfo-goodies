package DDG::Goodie::Calculator;

use DDG::Goodie;

zci is_cached => 1;
zci answer_type => "calc";

primary_example_queries '$3.43+$34.45';
secondary_example_queries '64*343';
description 'Basic calculations';
name 'Calculator';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Calculator.pm';
category 'calculations';
topics 'math';
attribution web => [ 'https://www.duckduckgo.com', 'DuckDuckGo' ],
            github => [ 'https://github.com/duckduckgo', 'duckduckgo'],
            twitter => ['http://twitter.com/duckduckgo', 'duckduckgo'];


triggers query_nowhitespace => qr<
        ^
       ( what is | calculate | solve | math )? !?

        [\( \) x X * % + / \^ \$ -]*

        (?: [0-9 \. ,]* )
        (?: gross | dozen | pi | e | c |)

        (?(1) (?: -? [0-9 \. ,]+ |) |)
        (?: [\( \) x X * % + / \^ \$ -] | times | divided by | plus | minus | cos | sin | tan | cotan | log | ln | log10 | exp )+

        (?: [0-9 \. ,]* )
        (?: gross | dozen | pi | e | c |)

        [\( \) x X * % + / \^ 0-9 \. , \$ -]* =? 

        $
        >xi;

handle query_nowhitespace => sub {
    my $results_html;
    my $results_no_html;
    my $query = $_;

    $query =~ s/^(?:whatis|calculate|solve|math)//;

    if($query !~ /[xX]\s*[\*\%\+\-\/\^]/ && $query !~ /^-?[\d]{2,3}\.\d+,\s?-?[\d]{2,3}\.\d+$/) {
        my $tmp_result = '';

        # Grab expression.
        my $tmp_expr = $query;


        #do the following substitutions in $tmp_expr:
        #^ -> **
        #x|times -> *
        #minus ->  -
        #plus -> +
        #dividedby -> /
        $tmp_expr =~ s# \^          # ** #xg;
        $tmp_expr =~ s# (?:x|times) # *  #xig;
        $tmp_expr =~ s# minus       # -  #xig;
        $tmp_expr =~ s# plus        # +  #xig;
        $tmp_expr =~ s# dividedby   # \/ #xig;

        # sub in constants
        # e sub is lowercase only because E == *10^n
        $tmp_expr =~ s/ ((?:\d+?|\s))E(-?\d+)([^\d]) /\($1 * 10**$2\)$3                             /xg;
        $tmp_expr =~ s/ (\d+?)e([^A-Za-z])           /$1 * 2.71828182845904523536028747135266249 $2 /xg;
        $tmp_expr =~ s/ ([^A-Za-z])e([^A-Za-z])      /$1 2.71828182845904523536028747135266249 $2   /xg;
        $tmp_expr =~ s/ \be\b                        /2.71828182845904523536028747135266249         /xg;
        $tmp_expr =~ s/ (\d+?)c([^A-Za-z])           /$1 * 299792458 $2                             /xig;
        $tmp_expr =~ s/ ([^A-Za-z])c([^A-Za-z])      /$1 299792458 $2                               /xig;
        $tmp_expr =~ s/ \bc\b                        /299792458                                     /xig;
        $tmp_expr =~ s/ (\d+?)pi                     /$1 * 3.14159265358979323846264338327950288    /xig;
        $tmp_expr =~ s/ pi                           /3.14159265358979323846264338327950288         /xig;
        $tmp_expr =~ s/ (\d+?)gross                  /$1 * 144                                      /xig;
        $tmp_expr =~ s/ (\d+?)dozen                  /$1 * 12                                       /xig;
        $tmp_expr =~ s/ dozen                        /12                                            /xig;
        $tmp_expr =~ s/ gross                        /144                                           /xig;

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
        if (defined $tmp_result && $tmp_result ne 'inf' && $tmp_result =~ /^(?:\-|)[0-9\.]+$/) {
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

            # Copy
            $results_no_html = $results_html = $tmp_q;

            # Superscript (before spacing).
            $results_html =~ s/\^([^\)]+)/<sup>$1<\/sup>/g;
            $results_html =~ s/\^(\d+|\b(?:e|c|dozen|gross|pi)\b)/<sup>$1<\/sup>/g;

            ($results_no_html, $results_html) = (spacing($results_no_html), spacing($results_html));
            return if $results_no_html =~ /^\s/;

            # Add commas.
            $tmp_result = commify($tmp_result);

            # Now add it back.
            $results_no_html .= ' = ';
            $results_html .= ' = ';

            $results_html = qq(<div>$results_html<a href="javascript:;" onClick="document.x.q.value='$tmp_result';document.x.q.focus();">$tmp_result</a></div>);
            return $results_no_html . $tmp_result, html => $results_html, heading => "Calculator";
        }
    }

    return;
};

#extra math functions
sub tan {
    my $x = $_[0];
    return sin($x)/cos($x);
}

sub cotan {
    my $x = $_[0];
    return cos($x)/sin($x);
}

sub log10 {
    my $x = $_[0];
    return log($x)/log(10);
}

#function to add a comma every 3 digits
#commify '12345'  -> '12,345'
sub commify {
    my $text = reverse $_[0];
    $text =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
    return scalar reverse $text;
}

#separates symbols with a space
#spacing '1+1'  ->  '1 + 1'
sub spacing {
    my $text = shift;
    $text =~ s/(\s*(?<!<)(?:[\+\-\^xX\*\/\%]|times|plus|minus|dividedby)+\s*)/ $1 /ig;
    $text =~ s/dividedby/divided by/ig;
    $text =~ s/(\d+?)((?:dozen|pi|gross|e|c))/$1 $2/ig;
    $text =~ s/\bc\b/speed of light/ig;

    return $text;
}
    

1;
