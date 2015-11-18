#!/usr/bin/perl
use strict;
use warnings;
use lib ("lib", "../lib");
use Test::Simple tests => 1;
$ENV{'PERL5LIB'} = "lib:../lib";
#1
{	
	my $result = system('find lib -iname "*.pm" | xargs -I perl -c {} 2>&1');
	ok($result == 0, "All modules compile");
}