#!/usr/bin/perl

use strict;
use warnings;

my $dir = "/ufrc/burleigh/nhans/summer2017/bird/NucGb/finalalignments/"; # The path
my @files = glob "$dir*.prune.fasta";
my $counter=0;


my $gzdir ="/ufrc/burleigh/nhans/summer2017/bird/NucGb/0-Data/";
my @gzfiles = glob "$gzdir*.tar.gz";
for (0..$#gzfiles){
  $gzfiles[$_] =~ s/\.tar.gz$//;
  
  my @ordering = split/\//,$gzfiles[$_];
  my $order=$ordering[8];
 
   print "$order\n";

  for (0..$#files){
    my $name= $files[$_];
    #print $name;
    #print "\n";

     my @splitname = split /\//,$name;
     my $splited = $splitname[8];
     #print $splited;

     $splited =~ s/\.prune.fasta//;
#     print $splited;
#     print "\n";

     $counter=$counter+1;
#     print $counter."\n";

    system("cp 2_runblast_pipeline.sh flag_$order/flagblast_$order.$splited.sh");
    system("cp 2_runblast_pipeline.pl flag_$order/");
    system("sed -i -e 's/coreNH/$splited/g' flag_$order/flagblast_$order.$splited.sh");
    system("sed -i -e 's/ORDERNH/$order/g' flag_$order/flagblast_$order.$splited.sh");
    ### Be careful with the following
#    system ("cd flag_$order");
    system("sbatch flag_$order/flagblast_$order.$splited.sh");
    }
}





