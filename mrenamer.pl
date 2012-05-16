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
    
    my @music;
    my @directories;
   
    while (my $file = readdir(DIR)) {
        next if($file =~ m/^\./);
        
        my $full_path = $work_dir . $file;
        
        push (@music, $full_path) if (-f $full_path);
        push (@directories, $full_path) if (-d $full_path);
    }
 
    closedir(DIR);

    foreach my $i(@music) {
        my $tags = Audio::Scan->scan_tags($i);
        print $i, "\n";
        if ($tags->{tags}->{TPE2} eq "" || $tags->{tags}->{TIT2} eq "") {
            print "null string $i\n";
        } 
        else {
            # will need to change the -4 to find the last . and then extension
            # because some file formats have 4 char extensions.
            my $file_extension = substr($work_dir . $i, -4);
            print $file_extension, "\n";
            my $new_name = $work_dir . $tags->{tags}->{TPE2} . " " .$tags->{tags}->{TIT2};
            #rename ($i, $new_name);
        }
    }
}

