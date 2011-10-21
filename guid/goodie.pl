
# This goodie will fire based on these keywords.
# We're using a lower case variable check, so all of these are lower case.
# We're also passing a 0 or 1 to use for varying types of results,
# in this case uuid vs guid but that could easily be undef.
my %guid = (
    'guid' => 0,
    'uuid' => 1,
    'globally unique identifier' => 0,
    'universally unique identifier' => 1,
    'rfc 4122' => 0,
    );

# If it matches the check,
# which may be a regular expression or other type of
# more complicated check, then we move on to calculating the answer.
if ($type ne 'E' && exists $guid{$q_check_lc}) {

# For debugging.
#    warn $q_check_lc;

    use Data::GUID;


    # We formulate the answer based upon potential subtypes.
    # In this case, we're distinguishing between UUIDs and GUIDs.
    if (my $guid = Data::GUID->new) {
        if ($guid{$q_check_lc}) {
            $guid = lc $guid;
        } else {
            $guid = qq({$guid});
        }

        $answer_results = $guid;
        $answer_type = 'guid';
	$type = 'E';
	$is_memcached = 0;
    }
}
