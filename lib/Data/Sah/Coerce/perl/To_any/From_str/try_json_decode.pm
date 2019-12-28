package Data::Sah::Coerce::perl::To_any::From_str::try_json_decode;

# AUTHOR
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;

sub meta {
    +{
        v => 4,
        summary => 'JSON-decode if we can, otherwise leave string as-is',
        prio => 50,
    };
}

sub coerce {
    my %args = @_;

    my $dt = $args{data_term};

    my $res = {};

    $res->{expr_match} = "!ref($dt)";
    $res->{modules}{"JSON::PP"} //= 0;
    $res->{expr_coerce} = join(
        "",
        "do { my \$decoded; eval { \$decoded = JSON::PP->new->allow_nonref->decode($dt); 1 }; \$@ ? $dt : \$decoded }",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|coerce)$

=head1 DESCRIPTION

This rule is sometimes convenient if you want to accept unquoted string or a
data structure (encoded in JSON). This means, compared to just decoding from
JSON, you don't have to always quote your string. But beware of traps like the
bare values C<null>, C<true>, C<false> becoming undef/1/0 in Perl instead of
string literals, because they can be JSON-decoded.
