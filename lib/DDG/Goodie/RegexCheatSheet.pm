package DDG::Goodie::RegexCheatSheet;
# ABSTRACT: Provide a cheatsheet for common Regular Expression syntax

use strict;
use warnings;

use DDG::Goodie;

zci answer_type => "regex_cheat";

triggers start => 
    'regex cheatsheet', 
    'regex cheat sheet', 
    'regex help', 
    'regexp cheatsheet', 
    'regexp cheat sheet', 
    'regexp help',
    'regex symbols', 
    'regex symbol',
    'regexp symbols', 
    'regexp symbol',
    'regex chars', 
    'regex char',
    'regexp chars', 
    'regexp char',
    'regex characters', 
    'regex character',
    'regexp characters', 
    'regexp character', 
    'regex', 
    'regexp', 
    'regular expressions',
    'regular expression',
    'regex guide',
    'regexp guide',
    'regular expression guide',
    'regexp reference',
    'regex reference',
    'regular expression reference';

triggers end => "regex", "regexp";

attribution github => ['https://github.com/mintsoft', 'mintsoft'];
primary_example_queries 'regex';
secondary_example_queries 'regexp $';
category 'computing_tools';

# The order to display each category and in which columns
my @category_column = (
    ['Anchors', 'Character Classes', 'POSIX Classes', 'Pattern Modifiers', 'Escape Sequences'],
    ['Quantifiers', 'Groups and Ranges', 'Assertions', 'Special Characters', 'String Replacement']
);

# Titles of tables and the symbols to explain
my %categories = (
    'Anchors' => [
        '^', '\A', '$', '\Z', '\b', '\B', '\<', '\>'
    ],
    'Character Classes' => [
        '\c', '\s', '\S', '\d', '\D', '\w', '\W', '\x', '\O'
    ],
    'POSIX Classes' => [
        '[:upper:]', '[:lower:]', '[:alpha:]', '[:alnum:]', '[:digit:]',
        '[:xdigit:]', '[:punct:]', '[:blank:]', '[:space:]', '[:cntrl:]',
        '[:graph:]', '[:print:]', '[:word:]'
    ],
    'Assertions' => [
        '?=', '?!', '?<=', '?!= or ?<!', '?>', '?()', '?()|', '?#'
    ],
    'Quantifiers' => [
        '*', '+', '?', '{3}', '{3,}', '{2,5}'
    ],
    'Escape Sequences' => [
        '\\', '\Q', '\E'
    ],
    'Special Characters' => [
        '\n', '\r', '\t', '\v', '\f', '\ooo', '\xhh'
    ],
    'Groups and Ranges' => [
        '.', '(a|b)', '(...)', '(?:...)', '[abc]', '[^abc]', '[a-q]', '[A-Z]', '[0-9]'
    ],
    'Pattern Modifiers' => [
        '//g', '//i', '//m', '//s', '//x', '//e', '//U'
    ],
    'String Replacement' => [
        '$n', '$2', '$1', '$`', q{$'}, '$+', '$&'
    ],
);

# Symbols and their explanation/description
my %syntax_map = (
    '.'      => 'Any character except newline (\n)',
    '(a|b)'      => 'a or b',
    '(...)'      => 'Group',
    '(?:...)'    => 'Passive (non-capturing) group',
    '[abc]'      => 'Single character (a or b or c)',
    '[^abc]'     => 'Single character (not a or b or c)',
    '[a-q]'      => 'Single character range (a or b ... or q)',
    '[A-Z]'      => 'Single character range (A or B ... or Z)',
    '[0-9]'      => 'Single digit from 0 to 9',
    '^'      => "Start of string or line",  
    '\A'         => "Start of string",
    '$'      => "End of string or line",
    '\Z'         => "End of string",
    '\b'         => 'Word boundary',
    '\B'         => 'Not word boundary',
    '\<'         => 'Start of word',
    '\>'         => 'End of word',
    '\c'         => 'Control character',
    '\s'         => 'Whitespace',
    '\S'         => 'Not Whitespace',
    '\d'         => 'Digit',
    '\D'         => 'Not digit',
    '\w'         => 'Word',
    '\W'         => 'Not Word',
    '\x'         => 'Hexadecimal digit',
    '\O'         => 'Octal Digit',
    '[:upper:]'  => 'Uppercase letters [A-Z]',
    '[:lower:]'  => 'Lowercase letters [a-z]',
    '[:alpha:]'  => 'All letters [A-Za-z]',
    '[:alnum:]'  => 'Digits and letters [A-Za-z0-9]',
    '[:digit:]'  => 'Digits [0-9]',
    '[:xdigit:]' => 'Hexadecimal digits [0-9a-f]',
#   '[:punct:]'  => 'Punctuation [\]\[!"#$%&'."'".'()*+,./:;<=>?@\^_`{|}~-]',
    '[:punct:]'  => 'Punctuation',
    '[:blank:]'  => 'Space and tab [ \t]',
    '[:space:]'  => 'Blank characters [ \t\r\n\v\f]',
    '[:cntrl:]'  => 'Control characters [\x00-\x1F\x7F]',
    '[:graph:]'  => 'Printed characters [\x21-\x7E]',
    '[:print:]'  => 'Printed characters and spaces  [\x20-\x7E]',
    '[:word:]'   => 'Digits, letters and underscore [A-Za-z0-9_]',
    '?='        =>  'Lookahead assertion',
    '?!'         => 'Negative lookahead',
    '?<='        => 'Lookbehind assertion',
    '?!= or ?<!' => 'Negative lookbehind',
    '?>'         => 'Once-only Subexpression',
    '?()'        => 'Condition [if then]',
    '?()|'       => 'Condition [if then else]',
    '?#'         => 'Comment',
    '*'      => '0 or more',
    '+'      => '1 or more',
    '?'      => '0 or 1 (optional)',
    '{3}'        => 'Exactly 3',
    '{3,}'       => '3 or more',
    '{2,5}'      => '2, 3, 4 or 5',
    '\\'         => 'Escape following character',
    '\Q'         => 'Begin literal sequence',
    '\E'         => 'End literal sequence',
    '\n'         => 'New line',
    '\r'         => 'Carriage return',
    '\t'         => 'Tab',
    '\v'         => 'Vertical tab',
    '\f'         => 'Form feed',
    '\ooo'       => 'Octal character ooo',
    '\xhh'       => 'Hex character hh',
    '//g'        => 'Global Match (all occurrences)',
    '//i'        => 'Case-insensitive',
    '//m'        => 'Multiple line',
    '//s'        => 'Treat string as single line',
    '//x'        => 'Allow comments and whitespace',
    '//e'        => 'Evaluate replacement',
    '//U'        => 'Ungreedy pattern',
    '$n'         => 'n-th non-passive group',
    '$2'         => '"xyz" in /^(abc(xyz))$/',
    '$1'         => '"xyz" in /^(?:abc)(xyz)$/',
    '$`'         => 'Before matched string',
    q{$'}       =>  'After matched string',
    '$+'         => 'Last matched string',
    '$&'         => 'Entire matched string',
);

sub are_valid_char_classes($$) {
    my ($a, $b) = @_;
    # must be both numbers or both lowercase or both uppercase
    if ($a =~ /[0-9]/ && $b =~ /[0-9]/ || $a =~ /[a-z]/ && $b =~ /[a-z]/ || $a =~ /[A-Z]/ && $b =~ /[A-Z]/) {
        return $b gt $a;
    }
    return;
}

sub difference_between($$) {
    my ($a, $b) = @_;
    return ord($b) - ord($a);
}

my $css = scalar share("style.css")->slurp;

sub append_css {
    my $html = shift;
    return "<style type='text/css'>$css</style>\n" . $html;
}

handle remainder => sub {
        my $heading = 'Regex Cheat Sheet';

    # If the user has requested information on a specific pattern.
    if (length $_ > 0) {
        my $syntax_key = $_;

        # Let the user provide [a-e], [1-2], nice simple examples only!
        if ($_ =~ /^\[([a-zA-Z0-9])\-([a-zA-Z0-9])\]$/) {
            return unless are_valid_char_classes($1, $2);
            #if there are < 3 between them then output all between them, otherwise "0 or 1 .. or 9" style
            my $range_string = "";
            if (difference_between($1, $2) < 3) {
                $range_string = join(" or ", ($1..$2));
            }
            else {
                $range_string = join(" or ", ($1..$2)[0,1]) . " ... or $2";
            }
            return answer => "$_ - Single character range ($range_string)",
                   html => "<code>$_</code> - Single character range ($range_string)",
                   heading => $heading;
        }
        # Let the user provide a number for the {n} pattern, e.g., {5} would say "Exactly 5 occurrences".
        elsif ($_ =~ /^\{([0-9]+)\}$/) {
            return answer => "$_ - Exactly $1 occurrences",
                   html => "<code>" . html_enc($_) . "</code> - Exactly " .  html_enc($_) . " occurrences",
                   heading => $heading;
        }
        # Let the user provide numbers for {n,} and {n,m}, e.g., {4,} would say "4 or more occurrences".
        elsif ($_ =~ /^\{([0-9]+),([0-9]+)?\}$/) {
            if ($2) {
                return unless ($1 < $2);
                return answer => "$_ - Between $1 and $2 occurrences", 
                       html => "<code>" . html_enc($_) . "</code> - Between $1 and $2 occurrences",
                       heading => $heading;
            }
            return answer => "$_ - $1 or more", 
                       html =>  "<code>" . html_enc($_) . "</code> - $1 or more occurrences",
                   heading => $heading;
        }
        # Check our map if it's in our list of regex patterns.
        return unless $syntax_map{$syntax_key};
    
        my $text_output = "$_ - $syntax_map{$syntax_key}";
        my $html_output = "<code>" . html_enc($_) . "</code> - " . html_enc($syntax_map{$syntax_key});
        return answer => $text_output, html => $html_output, heading => $heading;
    }
    
    # Otherwise display the complete tabular output, into n columns in the order specified.
    
    my $text_output = '';
    
    # Content of the div column wrapper.
    my @html_columns = ();
    
    # Add a helper function for adding the <td> tag.
    sub add_table_data {
        my ($text, $is_code) = @_;
        if($is_code) {
            return "<td><code>" . html_enc($text) . "</code></td>";
        }
        return "<td>" . html_enc($text) . "</tb>";
    }

    for(my $column = 0; $column < scalar(@category_column); ++$column) {
        for my $category  (@{$category_column[$column]}) {
            my $new_table = "<table class='regex-table'><b>$category</b>";

            $text_output .= "$category\n";

            for my $syntax_object (@{$categories{$category}}) {
                $new_table .= "<tr>" . add_table_data($syntax_object, 1) . add_table_data($syntax_map{$syntax_object}, 0) . "</tr>\n";
                $text_output .= "\t$syntax_object - $syntax_map{$syntax_object}\n";
            }
            
            $text_output .= "\n";                 
            $new_table .= "</table>\n";
            $html_columns[$column] .= $new_table;
        }
    }
    
    my $html_output = "<div class='regex-container'><div class='regex-column'>";
    $html_output .= join ("</div><div class='regex-column'>", @html_columns);
    $html_output .= "</div></div>";
    return answer => $text_output, html => append_css($html_output), heading => $heading;
};

1;
