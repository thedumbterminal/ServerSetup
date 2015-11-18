#!/usr/bin/perl
use strict;
use warnings;
use lib ("lib", "../lib");
use Diff;
use FindBin qw/$Bin/;
use local::lib "$Bin/../local";
use Digest::MD5;
use File::Copy;
use Sys::Hostname::FQDN qw(fqdn);
my $basePath = $ARGV[0];
my $hostname = fqdn();
print "Using hostname: $hostname\n";
my $startPath = $basePath . '/' . $hostname;
my @pending = ($startPath);
my @sFiles;
while(my $current = shift @pending){
  if(-d $current){	#read the contents of the directory
    if(opendir(DIR, $current)){
      foreach my $file (readdir(DIR)){
        if($file ne "." && $file ne ".." && $file ne ".svn" && $file !~ m/~$/){	#ignore unwanted files
          push(@pending, $current . '/' . $file);
        }
      }
      closedir(DIR);
    }
    else{
      die("Could not open dir: $!");
    }
  }
  else{	#add this file to the process list
    push(@sFiles, $current);
  }
}
my %changed;
#now process the found files
foreach my $file (@sFiles){
  my $status = "ERR";
  my $hex = _makeMd5($file);
  my $fFile = $file;
  $fFile =~ s/^$startPath//;
  my $fHex = _makeMd5($fFile);
  if(!$fHex){
    print "Remove this file from SVN? y/n: ";
    my $remove = <STDIN>;
    chomp $remove;
    if($remove eq "y"){
      system("svn remove --force $file");
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
    if(copy($fFile, $file)){	#copy worked
      print "...done\n";
    }
    else{
      die("Could not copy file: $fFile -> $file");
    }
  }
}
##########################################################
sub _makeMd5{
  my $file = shift;
  my $hex;
  if(open(FILE, "<$file")){
    binmode(FILE);
    my $md5 = Digest::MD5->new();
    $md5->addfile(*FILE);
    $hex = $md5->hexdigest();
    close(FILE);
  }
  else{
    die("Can't open: $file: $!\n");
  }
  return $hex;
}