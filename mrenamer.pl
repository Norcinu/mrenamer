#!/usr/bin/perl -w

use strict;
use warnings;
use Audio::Scan;
use Cwd;

sub StartUp {
    my ($start_dir) = $_;
    if (-d $start_dir) {
        if ($start_dir ne "/") {
            $start_dir .= "/";
            chdir $start_dir or die "Cant chdir to $start_dir\n"; 
            my $di = cwd;
            print $di, "\n";
        }
    }
    else {
        print "Please pass a folder argument not a file.\n";
    }    
}

sub FindExtension {
    my ($ext) = $_;
    # use regex in future.
    return substr($ext, -4);
}

# rename/check file in folder then parse all sub directories.
sub RenameFile {
    my ($mfile, $extension) = $@;

    my $tags = Audio::Scan->scan_tags($mfile);
    my $artist = $tags->{tags}->{TPE2};
    my $song = $tags->{tags}->{TIT2};

    if ($artist eq "" || $song eq "") {
        print "No available tags, not renaming file $mfile.\n";
    }
   
    rename ($mfile, $artist . " " . $artist . $extension);
}

sub ParseDirectory {
    my $start_dir = $_;
    if (-d $start_dir) {
        chdir $start_dir or die "Can't chdir to $start_dir.\n";
        my @directories;
        my @files;

        while (my $file = readdir(DIR)) {
            next if ($file =~ m/^\./);

            push(@music) if (-f $file);
            push(@directories) if (-d $file
        }
        closedir(DIR);

        if (length(@directories) > 0) {
            foreach my ($i) {
               &ParseDirectory($i);
            }
        }
        
        if (length(@files) > 0) {
            foreach my $i (@files) {
                my $extension = &FindExtension($i);
                &RenameFile($i, $extension);
            }
        }
    }
}

