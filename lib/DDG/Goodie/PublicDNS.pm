package DDG::Goodie::PublicDNS;

use DDG::Goodie;

use List::Util qw(max);

primary_example_queries 'public dns';
description 'list common public DNS servers and their IP addresses';
name 'Public DNS';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/PublicDNS.pm';
category 'cheat_sheets';
topics 'sysadmin';

attribution github => ['https://github.com/warthurton', 'warthurton'];

triggers end => "public dns", "dns servers";

zci is_cached   => 1;
zci answer_type => "public_dns";

# Let them add new entries anywhere, but store them lexically.
# Done like this to allow for manual (or other) sorting should the
# need arise.
my @ordered_servers = sort { $a->{provider} cmp $b->{provider} } ({
        provider => 'Comodo Secure DNS',
        ip4      => ['8.26.56.26', '8.20.247.20'],
        ip6      => [],
        info_url => 'http://www.comodo.com/secure-dns/',
    },
    {
        provider => 'DNS Advantage',
        ip4      => ['156.154.70.1', '156.154.71.1'],
        ip6      => [],
        info_url => 'http://dnsadvantage.com',
    },
    {
        provider => 'Google Public DNS',
        ip4      => ['8.8.8.8', '8.8.4.4'],
        ip6      => ['2001:4860:4860::8888', '2001:4860:4860::8844'],
        info_url => 'http://code.google.com/speed/public-dns/',
    },
    {
        provider => 'Norton DNS',
        ip4      => ['198.153.192.1', '198.153.194.1'],
        ip6      => [],
        info_url => 'http://dns.norton.com',
    },
    {
        provider => 'OpenDNS',
        ip4      => ['208.67.222.222', '208.67.220.220'],
        ip6      => [],
        info_url => 'http://opendns.com/',
    },
);

# Today we could just change and use the key names, but I have no idea what the future holds.
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
my $css  = share("style.css")->slurp;
my $html = '<style type="text/css">' . $css . '</style><table class="publicdns">';

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

handle sub {
    $text, html => $html;
};

sub _max_str_len {
    my $item = shift;

    # We only have strings or arrays, so the max length of a string is the length of the string itself.
    return (ref $item eq 'ARRAY') ? length(join($layout->{text_array}, @$item)) : length $item;
}

1;
