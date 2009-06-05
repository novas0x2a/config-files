#!/usr/bin/perl
use strict;
use warnings;

use Data::Dumper qw/Dumper/;

sub usage {
    die "Usage: $0 <prefix> <tagfile>\n";
}

my $prefix  = shift || usage;
my $tagfile = shift || usage;

open(TAGS, '<', $tagfile) or die;

# vwClass   c,s,u
# vwType    t
# vwEnum    g
# vwName    n
# vwMacro   d
# vwConst   e
# vwFunc    f,p

my %ids = (
    c => 'Class',
    s => 'Class',
    u => 'Class',
    t => 'Type',
    g => 'Enum',
    n => 'Namespace',
    d => 'Macro',
    e => 'Const',
#    f => 'Func',
#    p => 'Func'
);

my %data;

my @skip = (
#    qr/value_type$/,
#    qr/Options$/
);

my $ns = qr/([^:]+)$/;

LINE: while (my $line = <TAGS>)
{
    chomp $line;
    my ($name, undef, undef, $id) = split(/\t/, $line);

    #warn "NAME[$name] ID[$id]\n";
    next unless defined $id and exists $ids{$id};

    foreach (@skip) {
        next LINE if $name =~ $_;
    }

    $name =~ $ns;

    push(@{$data{$ids{$id}}}, $1);
}

my %uniq;
my @uniq;
while (my ($key, $value) = each %data) {
    #warn "$key: ", Dumper($value), "\n";
    print "syn keyword ${prefix}${key} ";

    %uniq = ();
    $uniq{$_}++ foreach @$value;
    @uniq = grep(!/^_/, keys %uniq);

    print join(' ', @uniq), "\n";
}

print <<EOF
if version >= 508
  command -nargs=+ HiLink hi def link <args>
  HiLink ${prefix}Class      Type
  HiLink ${prefix}Type       Type
  HiLink ${prefix}Typedef    Type
  HiLink ${prefix}Enum       Type
  HiLink ${prefix}Namespace  Type
  HiLink ${prefix}Macro      Macro
  HiLink ${prefix}Const      Constant
  HiLink ${prefix}Func       Function

  delcommand HiLink
endif
EOF

__END__

    c  classes
    s  structure names
    t  typedefs
    d  macro definitions
    e  enumerators (values inside an enumeration)
    f  function definitions
    p  function prototypes
    u  union names
    g  enumeration names
    n  namespaces
