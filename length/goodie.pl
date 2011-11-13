
# Outputs the numerical length of the query.

if (!$type && $q_check =~ m/^length (.+)$/i) {

    # Encode isn't necessary since the query is already unicode,
    # and in a character setting.
#      {   
#        use Encode;
#        $answer_results = length decode_utf8($1);
#      }
        $answer_results = length $1;

        if ($answer_results) {
                $answer_results = qq(Length: $answer_results);
                $answer_type = 'length';
                $type = 'E';
        }
}

