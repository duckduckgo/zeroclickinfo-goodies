package DDG::Goodie::PublicDNS;
# ABSTRACT: Display a list of DNS servers which accept public queries.

use DDG::Goodie;

use List::Util qw(max);
use YAML qw( Load );

primary_example_queries 'public dns';
description 'list common public DNS servers and their IP addresses';
name 'Public DNS';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/PublicDNS.pm';
category 'cheat_sheets';
topics 'sysadmin';

attribution github => ['warthurton', 'Wayne Arthurton'];

triggers end => "public dns", "dns server", "dns servers";

zci is_cached   => 1;
zci answer_type => "public_dns";

my $providers = Load(scalar share('providers.yml')->slurp);

my @ordered_servers;
# Alphabetize the output while making the structure
# Easier to use below.  The YAML is for human editing.
foreach my $provider (sort keys %$providers) {
    my $info = $providers->{$provider};
    $info->{provider} = $provider;
    push @ordered_servers, $info;
}

undef $providers;    # We're done with this now.

# Let the YAML stay the same, even if column ordering or titling changes.
my @display_cols = ({
        key   => 'provider',
        title => 'Provider',
    },
    {
        key   => 'ip4',
        title => 'IPv4',
    },
    {
        key   => 'ip6',
        title => 'IPv6',
    },
);

my $layout = {
    extra_space => 1,         # How many extra spaces in the text table?
    text_corner => '+',
    text_line   => '-',
    text_col    => '|',
    text_array  => ', ',
    html_array  => '<br/>',
};

foreach my $column (@display_cols) {
    $column->{width} = max(map { _max_str_len($_->{$column->{key}}) } @ordered_servers);
    $column->{text_spacer} = sub {
        my $to_show = shift;
        # Everything is left-aligned
        return
            $layout->{text_col}
          . (' ' x $layout->{extra_space})
          . $to_show
          . (' ' x max(0, $column->{width} - length($to_show) + $layout->{extra_space}));
    };
}

my $table_spacer =
  join($layout->{text_corner}, '', (map { $layout->{text_line} x ($_->{width} + $layout->{extra_space} * 2) } @display_cols), '') . "\n";

# Actually build the output.. finally!
my $text = $table_spacer;
my $html = '<table class="publicdns">';

# First the headers
$text .= join('', map { $_->{text_spacer}->($_->{title}) } @display_cols);
$html .= '<tr><th>' . join('</th><th>', map { $_->{title} } @display_cols) . '</th></tr>';
$text .= "|\n" . $table_spacer;

# And now the content
foreach my $server (@ordered_servers) {
    $html .= "<tr>";
    foreach my $column (@display_cols) {
        if ($column->{key} ne 'provider') {
            # Assuming we aren't displaying any non-provider string types!
            $text .= $column->{text_spacer}->(join($layout->{text_array}, @{$server->{$column->{key}}}));
            $html .= '<td>' . (join($layout->{html_array}, @{$server->{$column->{key}}})) . '</td>';
        } else {
            # Special-case provider
            $text .= $column->{text_spacer}->($server->{$column->{key}});
            $html .= '<td><a href="' . $server->{info_url} . '">' . $server->{$column->{key}} . '</a></td>';
        }
    }
    $text .= $layout->{text_col} . "\n";
    $html .= '</tr>';
}

$text .= $table_spacer;
$html .= '</table>';

my $heading = 'Public DNS Servers';

handle sub {
    $text,
      html    => $html,
      heading => $heading;
};

sub _max_str_len {
    my $item = shift;

    # We only have strings or arrays, so the max length of a string is the length of the string itself.
    return (ref $item eq 'ARRAY') ? length(join($layout->{text_array}, @$item)) : length $item;
}

1;
