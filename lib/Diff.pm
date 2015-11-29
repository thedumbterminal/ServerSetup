#diff two files and returns an boolean result
package Diff;
use warnings;
use strict;
our $version = 1;
#############################################################
sub diff{
	my($class, $file1, $file2) = @_;
	my $output = $class->fullDiff($file1, $file2);
	$output ne "";	#files are different
}
#############################################################
sub fullDiff{
	my($class, $file1, $file2) = @_;
	open(DIFF, "/usr/bin/diff $file1 $file2 |") or die("Cant run diff for $file1 & $file2 : $!");
	my $output = "";
	while(my $line = <DIFF>){
		$output .= $line;
	}
	close(DIFF);
	return $output;
}
###############################################################################
1;
