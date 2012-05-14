#!/usr/bin/perl

use strict;
use warnings;
use Audio::Scan;

if ($ARGV[0] ne "") {
    my $work_dir = $ARGV[0];
    my $index = substr($work_dir,-1,1);
    if ($index ne "/") {
        print "need to add a slash\n";
        $work_dir .= "/";
        print $work_dir, "\n";
    }

    opendir(DIR, $work_dir) || die "Could not open directory: $work_dir\n";

    my @music = readdir(DIR);
    foreach my $i(@music) {
        my $tags = Audio::Scan->scan_tags($work_dir . $i);
        print $tags->{tags}->{TPE2}, "\n";
    }
    closedir(DIR);
}

#print $tags->{tags}->{TFLT}, "\n";

# pass directory path as argument.
#sub print_msg {
    #print "mrenamer - renaming files the ipod/itunes likes to mess up.\n";
#}

#&print_msg;

#$numargs = $#ARGV+1;
#print "$numargs number of args.\n";

#foreach $argnum (0..$#ARGV) {
 #   print "$ARGV[$argnum] ";
#}

#print "\n";

#sub print_names {
 #   @names=('Steven Gleed','Emilie Dejon-Stewart', 'Jimmy-Bill from Muswell hill');
  #  foreach $x (@names) {
   #     print "$x ";
    #}
    #print "\n";
#}
#&print_names;
