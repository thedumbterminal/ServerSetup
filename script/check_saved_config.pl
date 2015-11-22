#!/usr/bin/env perl
use strict;
use warnings;
use lib ("lib", "../lib");
use Diff;
use FindBin qw/$Bin/;
use local::lib "$Bin/../local";
use Digest::MD5::File qw(file_md5_hex);
use File::Copy;
use Sys::Hostname::FQDN qw(fqdn);
die("Usage: $0 <directory>\n") unless $ARGV[0];
my $basePath = $ARGV[0];
my $startPath = $basePath . '/' . fqdn();
print "Using config path: $startPath\n";
my @pending = ($startPath);
my @sFiles;
my @unwanted = (
	qr/^\.+$/,
	qr/^\.svn$/,
	qr/^\.git$/,
	qr/~$/
);
while(my $current = shift @pending){
	if(-d $current){	#read the contents of the directory
		opendir(DIR, $current) or die("Could not open dir: $!");
		foreach my $file (readdir(DIR)){
			my $wanted = 1;
			foreach my $check (@unwanted){
				if($file =~ /$check/){
					$wanted = 0;
				}
			}
			if($wanted){	#ignore unwanted files
				push(@pending, $current . '/' . $file);
			}
		}
		closedir(DIR);
	}
	else{	#add this file to the process list
		push(@sFiles, $current);
	}
}
my %changed;
#now process the found files
foreach my $file (@sFiles){
	my $status = "ERR";
	my $hex = file_md5_hex($file);
	my $fFile = $file;
	$fFile =~ s/^$startPath//;
	my $fHex = file_md5_hex($fFile);
	if(!$fHex){
		print "Remove file $file from the config? y/n: ";
		my $remove = <STDIN>;
		chomp $remove;
		if($remove eq "y"){
			unlink($file);
			print "...Done\n";
			$status = "GONE";
		}
	}
	else{
		if($fHex eq $hex){
			$status = "OK";
		}
		else{
			$changed{$file} = $fFile;
		}
	}
	print $status . "\t" . $hex . "\t" . $file . "\n";
}
#now show diffs
foreach my $file (keys %changed){
	print "Press enter to show the diff for: $file";
	my $enter = <STDIN>;	#read in a line
	my $fFile = $changed{$file};
	print Diff->fullDiff($file, $fFile);
	print "Copy this file into SVN? y/n: ";
	my $copy = <STDIN>;
	chomp $copy;
	if($copy eq "y"){	#copy file
		copy($fFile, $file) or die("Could not copy file: $fFile -> $file");
		print "...done\n";
	}
}
