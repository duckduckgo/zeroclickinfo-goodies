package DDG::Goodie::GermanPhonePrefix;

# ABSTRACT: Look up area/county/town for German phone prefix

use DDG::Goodie;
use strict;

zci answer_type => 'german_phone_prefix';

# Caching - https://duck.co/duckduckhack/spice_advanced_backend#caching-api-responses
zci is_cached => 1;

# triggers are in German deliberately
triggers any => 'vorwahl', 'telefonvorwahl';

my %prefix_db;
my %db_data = share("german_phone_prefix_database.txt")->slurp(iomode => '<:encoding(UTF-8)');
foreach (%db_data) {
    chomp;
    my (@f) = split(' ', $_, 2);
    push (@{$prefix_db{$f[0]}}, $f[1]);
}

# Handle statement
handle remainder => sub {

    my $remainder = $_;

    # we have to have input
    return unless $remainder;

    # only 3-6 digits are accepted
    return unless $_ =~ /^\d{3,6}$/;
    
    my @results;
    if (exists $prefix_db{$remainder}) {
        @results = @{$prefix_db{$remainder}};
    } else {
        return;
    }
    
    @results = sort @results; 
    my $result = join(", ", @results);
    
    return $result,
        structured_answer => {
            input       => [html_enc($remainder)],
            operation   => 'Lookup German phone prefix',
            result      => html_enc($result)
        };
};

1;
