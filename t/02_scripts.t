#!/usr/bin/env perl
use strict;
use warnings;
use FindBin qw/$Bin/;
use local::lib "$Bin/../local";
use File::Find;
use Test::Simple tests => 1;

find(\&checkFile, ('script'));	

#########################################################
sub checkFile{
	my $file = $_;
	if($file =~ m/.+\.pl$/){
		my $result = system('perl -c ' . $file . ' 2>&1');
		ok($result == 0, $file . " compiles");
	}
}