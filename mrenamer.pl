#!/usr/bin/perl -w

use strict;
use warnings;
use Audio::Scan;
use Cwd;

=comment
sub StartUp($) {
    my ($start_dir) = $_[0];
    print $start_dir, "\n";
    if (-d $start_dir) {
        if ($start_dir ne "/") {
            $start_dir .= "/";
            chdir $start_dir or die "Cant chdir to $start_dir\n"; 
            my $di = cwd;
            print $di, "\n";
        }
    }
    else {
        print "Please pass a valid folder.\n";
    }    
}
=cut
sub ParseDirectory($) {
    my $start_dir = $_[0];
    print $start_dir, "\n";
    if (-d $start_dir) {
        my $index = substr($start_dir, -1,1);
        
        if ($index ne "/") {
            $start_dir .= "/";
        }

        chdir $start_dir or die "Can't chdir to $start_dir.\n";
        my @directories;
        my @files;
        
        opendir(DIR, $start_dir) or die "Cannot open the directory: 
            $start_dir.\n";
        
        while (my $file = readdir(DIR)) {
            next if ($file =~ m/^\./);

            my $full_path = $start_dir . $file;
            print $full_path, "\n";

            push(@files, $full_path) if (-f $full_path);
            push(@directories, $full_path) if (-d $full_path);
        }
        
        closedir(DIR);

        if (length(@directories) > 0) {
            foreach my $i (@directories) {
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

sub FindExtension($) {
    my ($ext) = $_[0];
    # use regex in future.
    return substr($ext, -4);
}

# rename/check file in folder then parse all sub directories.
sub RenameFile() {
    my ($mfile, $extension) = @_;

    my $tags = Audio::Scan->scan_tags($mfile);
    my $artist = $tags->{tags}->{TPE2};
    my $song = $tags->{tags}->{TIT2};

    if ($artist eq "" || $song eq "") {
        print "No available tags, not renaming file $mfile.\n";
    }
   
    rename ($mfile, $artist . " " . $artist . $extension);
}

#StartUp($ARGV[0]);
ParseDirectory($ARGV[0]);

