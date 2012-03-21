package DDG::Goodie::GUID;

use DDG::Goodie;
use Data::GUID;

triggers start => 'globally', 'universally', 'rfc', 'guid', 'uuid';
zci answer_type => "GUID";
my %guid = (
    'guid' => 0,
    'uuid' => 1,
    'globally unique identifier' => 0,
    'universally unique identifier' => 1,
    'rfc 4122' => 0,
    );

handle query_lc => sub {
    return unless exists $guid{$_};
    if (my $guid = Data::GUID->new) {
        if ($guid{$_}) {
            $guid = lc $guid;
        } else {
            $guid = qq({$guid});
        }
	$guid .= ' (randomly generated)';
        return $guid;
    }
    return;
};
1;
