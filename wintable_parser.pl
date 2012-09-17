#!/usr/bin/perl -w

use strict;
use warnings;

my @directories = ('wins', 'loses', 'features');
my @outcomes;

my $array_prefix = "outcome_";
my $root_work_dir = $ARGV[0];
my $output_file = $ARGV[1];

sub ParseDirectory($) {
    opendir(DIR, $_[0]) or die "Cannot open directory.\n";

    while (my $file = readdir(DIR)) {
        open(F, $file);
        while (<F>) {
            chomp;
            print "$_\n";
        }
    }
}

sub WriteLines() {
}

ParseDirectory($root_work_dir);
