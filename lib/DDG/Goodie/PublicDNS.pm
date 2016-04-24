package DDG::Goodie::PublicDNS;
# ABSTRACT: Display a list of DNS servers which accept public queries.

use strict;
use DDG::Goodie;

use List::Util qw(max);
use YAML::XS 'LoadFile';

triggers end => "public dns", "dns server", "dns servers";

zci is_cached   => 1;
zci answer_type => "public_dns";

my $providers = LoadFile(share('providers.yml'));

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

# First the headers
$text .= join('', map { $_->{text_spacer}->($_->{title}) } @display_cols);
$text .= "|\n" . $table_spacer;

# And now the content
foreach my $server (@ordered_servers) {
    foreach my $column (@display_cols) {
        if ($column->{key} ne 'provider') {
            # Assuming we aren't displaying any non-provider string types!
            $text .= $column->{text_spacer}->(join($layout->{text_array}, @{$server->{$column->{key}}}));
        } else {
            # Special-case provider
            $text .= $column->{text_spacer}->($server->{$column->{key}});
        }
    }
    $text .= $layout->{text_col} . "\n";
}

$text .= $table_spacer;

handle sub {
    return $text,
    structured_answer => {
        data => {
            title => 'Public DNS Servers',
            list => \@ordered_servers,
        },
        templates => {
            group => 'list',
            options => {
                list_content => 'DDH.public_dns.content',
            }
        }
     };
};

sub _max_str_len {
    my $item = shift;

    # We only have strings or arrays, so the max length of a string is the length of the string itself.
    return (ref $item eq 'ARRAY') ? length(join($layout->{text_array}, @$item)) : length $item;
}

1;
