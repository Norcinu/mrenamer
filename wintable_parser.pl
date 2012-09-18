#!/usr/bin/perl -w

use strict;
use warnings;

my @directories = ('\\wins\\', '\\loses\\', '\\features\\');
my @outcomes;
my @files; 
my @file_lengths;
my %outcomes_to_write;

my $array_prefix = "outcome_";
my $root_work_dir = $ARGV[0];
my $output_file = $ARGV[1];
my $samples = 0;
my $current_file = 0;

sub ParseDirectory($) {
    opendir(DIR, $_[0]) or die "Cannot open directory.\n";
	my $line_counter = 0;
	my $i = 0;

	my @temp;
#	my @file_lengths;

    while (my $file = readdir(DIR)) {
		next if ($file =~ m/^\./);

		print $file, "\n";
		
		my $full_path = $_[0] . $file;
		if (-f $_[0] . $full_path) {
			open(F, $full_path) or die $!; 
			my @lines;
			my $outcome_name = '';

			while (<F>) {
				chomp;
				$line_counter++;
				$outcome_name = $array_prefix . $file;
				print $_;
				my $l = push(@lines, $_);
#				print $l, " ";
				#	print $lines[0], " ";
				#	print $lines[$l];
				#print "$_\n";
			}
			
			$outcomes_to_write{$outcome_name} = [@lines];
			
			close(F);
			
			push (@file_lengths, $line_counter);
			#undef (@lines);

			$line_counter = 0;
		}
    }

	closedir(DIR);
}

sub WriteLines($) {
#	my $array_name = keys $outcomes;
	my $array_name = '';
	open(F, '>>' . $root_work_dir . 'outcomes.h');

	print F $array_name . "[" . $samples. "][15] = {\n";
	while ((my $key, my $value) = each %outcomes_to_write) {
		print "$key $value", "\n";
		#for (my $ctr = 0; $ctr < length($value); $ctr++) {
			print $outcomes_to_write{$value};
			#}
	}
##	for ($ctr = 0; $ctr < $samples / 3; $ctr++) {
##		print F %outcomes{$array_name}
##	}
	#foreach my $i (keys %outcomes_to_write) {
	#	print F $i . "\n";
	#}
	
	print F "\n}; // End of $array_name \n\n";

	close(F);
}

sub SetAverageSampleCap($) {
	if ($_[0] >= 1000) {
		$samples = 333*3;
	}
	elsif ($_[0] >= 500) {
		$samples = 166*3;
	}
	elsif ($_[0] >= 100) {
		$samples = 33*3;
	}
	elsif ($_[0] >= 30) { 
		$samples = 30;
	}
	elsif ($_[0] >= 10) {
		$samples = 9;
	}
	else {
		$samples = 1;
	}
}

sub SetSampleCap($) {
	if ($_[0] >= 1000) {
		$samples = 1000;
	}
	elsif ($_[0] >= 500) {
		$samples = 500;
	}
	elsif ($_[0] >= 100) {
		$samples = 100;
	}
	elsif ($_[0] >= 30) { 
		$samples = 30;
	}
	elsif ($_[0] >= 10) {
		$samples = 10;
	}
	else {
		$samples = 1;
	}
}

sub StripExtension() {
}

ParseDirectory($root_work_dir);
WriteLines("temp.txt");

