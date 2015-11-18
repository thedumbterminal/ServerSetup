#diff two files and returns an integer result
package Diff;
BEGIN {
	use warnings;
	use strict;
	our $version ="1";	#version of this software
}
#############################################################
sub diff{
	my($class, $file1, $file2) = @_;
	my $output = $class->fullDiff($file1, $file2);
	if($output){	#files are different
		return 1;
	}
	else {	#files are the same
		return 0;
	}
}
#############################################################
sub fullDiff{
	my($file1, $file2) = @_;
	my $output = "";
	if(open(DIFF, "/usr/bin/diff $file1 $file2 |")){
		while(<DIFF>){$output .= $_;}
		close(DIFF);
	}
	else{
		die("Cant run diff for $file1 & $file2 : $!\n");
	}
	return $output;
}
###############################################################################
return 1;
END {}
