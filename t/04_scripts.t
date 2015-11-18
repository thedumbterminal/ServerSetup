#!/usr/bin/perl
use strict;
use warnings;
use Test::Simple tests => 1;
#1
{	
	my $result = system('find script -iname "*.pl" | xargs -i perl -Tc {} 2>&1');
	ok($result == 0, "All scripts compile");
}