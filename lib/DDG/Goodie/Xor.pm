package DDG::Goodie::Xor;

use DDG::Goodie;

triggers any => 'xor', '⊕';

zci is_cached => 1;

handle query_raw => sub {
    my @nums = grep(!/(xor|⊕)/, split(/\s+(⊕|xor)\s+/i, $_));
    my $num = 0;
    foreach (@nums) {
        $num ^= ord(chr($_)) if $_ =~ /^\d+$/;
        return unless $_ =~ /^\d+$/;
    }
    return "$num" if $num;
    return;
}
