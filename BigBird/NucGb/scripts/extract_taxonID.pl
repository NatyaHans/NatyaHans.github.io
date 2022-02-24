#!/usr/bin/perl -w
use Data::Dumper; 


$infile = $ARGV[0];
die ("Missing input file\n") if (!(-e $infile));


open FH1, "<$infile";
open FH2, ">taxonID_columbiformes.txt";

$/="\n//\n";
while(<FH1>){
     $aa=$_;
     if($aa=~ /ORGANISM(.*?)REFERENCE(.*?)\/organism=\"(.*?)\"(.*?)\/db_xref=\"taxon:?(\d+)\"(.*?)CDS\s+([\S\s]+?)\/(\w+)=\"(\w+)\"[\s\S\n]+?translation=\"([\w\s]+)\"/gis){
#        print "$3\n\n";
        $org = $3; #organism namee
        $taxon = $5; #name of the taxa
        print FH2 "$org: $taxon\n";
        }
   }     

close FH1;
close FH2;

print "And its done!! yay";
