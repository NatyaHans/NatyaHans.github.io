#!/usr/bin/perl -w
use Data::Dumper;

system "ls -l *.trimmed.fasta.muscle.fasta >allfiles"; #OPENS All the edited.fasta(output from the previous script edited_fasta.pl)
$countingseq=0;
open FHx, "<allfiles"; #opens all files with this file name
while (<FHx>){
#open each edited fasta file
    if (/(\S+).trimmed.fasta.muscle.fasta/){
        $file = $1; #assigns the $1 which is the file name to the variable $file
	print "$file\n"; #prints the name of the file on terminal
	open FH, "<$file.trimmed.fasta.muscle.fasta"; #opens that file
        open OUT, ">$file.align.fasta";
        
	while ($line=<FH>){
            chomp $line;
            if ($line=~/^>(.*)/){
                $header = $1;
                #print $header."\n";
                $countingseq=$countingseq+1;
	        print OUT "\n>$header\n";  
                #print $skip."\n";       # skip this top line 
                }
	    else{
                $seq=$line;
                #$seq =~ s/-//g;
                print OUT $seq;
                }
            #print OUT "\n";
	    }     
         close OUT;
        }
         
    }
close FH;
close FHx;
system("sed -i '1d' *.align.fasta");
print "it's done...phew\n";
print "total sequences: $countingseq";
