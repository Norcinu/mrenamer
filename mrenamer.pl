#!/usr/bin/perl
# pass directory path as argument.

sub print_msg {
    print "mrenamer - renaming files the ipod/itunes likes to mess up.\n";
}

&print_msg;

$numargs = $#ARGV+1;
print "$numargs number of args.\n";

foreach $argnum (0..$#ARGV) {
    print "$ARGV[$argnum] ";
}

print "\n";

