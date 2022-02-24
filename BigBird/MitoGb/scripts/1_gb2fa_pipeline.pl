#*****************************************************************************************************************#
# This is the first script in the pipeline that converts the downloaded Genbank Dataset into fasta format         #
# Comment this heavily NH                                                                                         #
#-----------------------------------------------------------------------------------------------------------------


#!/usr/bin/perl -w
use Data::Dumper; 

############### Modified by NH

# ----- initializations ---------------------------------------------------------------------------
MAIN: {
$infile = $ARGV[0]; # first argument is the genbank file with format
$outfile = $ARGV[1]; # second argument is the output file name 

#For non coding sequences:
$culledfile ="$outfile.ncds.gnb"; # this has the non coding genbank sequences
$fastafile = "$outfile.ncds.fasta"; #  non coding fasta sequences
$tablefile = "$outfile.ncds.table"; # non coding table - tab delimited

#For coding sequences
$aafile= "$outfile.aa.fasta"; # coding amino acid sequences
$fastafile_mod= "$outfile.cds.fasta"; # coding fast
$tablefile_mod= "$outfile.cds.table";

#die if no infine(.gb) is provided
die ("Missing input file\n") if (!(-e $infile));

#die if the file name already exists(prevents overwriting of the files )
die ("Output file(s) $culledfile, $fastafile, $tablefile, $aafile, $fastafile_mod,or $tablefile_mod already exist\n") if ((-e $culledfile) || (-e $fastafile) || (-e $tablefile) || (-e $aafile) || (-e $fastafile_mod) || (-e $tablefile_mod)) ;

#setting the criterias
$sizeCriterion = 1000000;
$moleculeCriterion = "DNA";

#initializing
$accepted=0;
$notDNA=0;
$DNAbutTooBig=0;
$totalEvaluated=0;
$NCSeq=0;

# ----- read genbank flatfile, select records to include, make new files --------------------------

open FH1, "<$infile";
open FH2, ">$culledfile";
open FH3, ">$fastafile";
open FH4, ">$tablefile";

open FH5, ">$aafile"; #contains aa sequences from cds
open FH6, ">$fastafile_mod"; #contains modified ntd sequences modified based on cds
open FH7, ">$tablefile_mod"; #modified table


#very important line
$/="\n//\n";
while (<FH1>){
     $record = $_;
     if($record =~ /LOCUS\s+\w+\s+(\d+)\sbp.+\b$moleculeCriterion\b/){
         $length = $1;
	 if($length <= $sizeCriterion){
             if($record=~/CDS/){  # NH here CDS is matched after passing the length criteria
                 ($gi,$ti,$org,$defn ,$fastaNtd, $fastaAA,$fam) =(&extractAA($record));               
                  print FH5 "$fastaAA\n";   #NH adds to amino acid fasta file
                  print FH6 "$fastaNtd\n"; #NH adds to modified ntd sequence
                  print FH7"acc-$gi\|ti-$ti\|$fam\|$length\|$org\|$defn\n";  # NH adds to modified aa table #####PROBLEM
                 ++$accepted;
                 }
             else{
                 ($gid, $tid, $taxon, $product, $defline, $sequence,$fam) = (&extractGnb($record));
	          if(! exists $taxonHash{$taxon}){
                      $taxonHash{$taxon} = ($tid);
                      }
		  print FH2 "$record";							# add to new culled genbank file
		  print FH3 ">$defline\n$sequence\n\n";					# add to fasta file
		  print FH4 "acc-$gid\|ti-$gid\|$fam\|$length\|$taxon\|$product\n";		# add to translation table
              	  ++$NCSeq;
                 }	   
         }
	else {++$DNAbutTooBig;}
     }
     else {++$notDNA;}
     ++$totalEvaluated;
}   

close FH1;
close FH2;
close FH3;
close FH4;
close FH5;
close FH6;
close FH7;

die ("doesn't add up") if (! $totalEvaluated == ($accepted+$notDNA+$DNAbutTooBig+$NCSeq));
print "total\tnot DNA\tlarge DNA\tnon-coding\taccepted\n\n$totalEvaluated\t$notDNA\t$DNAbutTooBig\t$NCSeq\t$accepted\n";
}

# ------ subroutine to extract info from genbank format -------------------------
 
sub extractGnb {
my ($gnb)=@_;
($locus) = ($gnb =~ /LOCUS\s+([\w\.]+)\s+/);
($defn) = ($gnb =~ /DEFINITION\s+(.+)ACCESSION/s);
$defn =~ s/\n//g; $defn =~ s/\s+/ /g;
($vers) = ($gnb =~ /VERSION\s+([\w\d\.]+)\s+/);
#print $vers;
($gi) = ($gnb =~ /ACCESSION\s+(.*?)\s+/);
($org) = ($gnb =~ /ORGANISM\s+(.+)/);
print $org;
($ti) = ($gnb =~ /db_xref=["']taxon:(\d+)["']/);
($seq) = ($gnb =~ /ORIGIN[^\n]*\n(.+)/s);
chomp $seq; $seq =~ s/\d//g; $seq =~ s/\s//g;
$defline = "acc-$gi\|ti-$ti\|gb-$vers\|locus-$locus\|def-$defn";	
($family)=($gnb=~/ORGANISM(.*?)REFERENCE/gis);
chomp $family; $family=~ s/\s//g; $family=~s/\;/\n\*/g;
if($family=~m/\*(.*idae)/){
$fam=$1;
}
		# HACK: gb is in place of the database source.
return ($gi, $ti, $org, $defn, $defline, $seq,$fam);

}


#------------------------subroutine to extract aa info from genbank format ---------NH---------

sub extractAA{
    my ($aa)= @_;

    ####----copied from extractGnB
    ($locus) = ($aa =~ /LOCUS\s+([\w\.]+)\s+/);
    ($defn) = ($aa =~ /DEFINITION\s+(.+)ACCESSION/s);
    $defn =~ s/\n//g; $defn =~ s/\s+/ /g;
#    ($vers, $gim) = ($aa =~ /VERSION\s+(\S+)\s+GI:?(\d+)/);
#    ($vers) = ($aa =~ /VERSION\s+(.*?[.]\d+)\s+/);
     ($vers) = ($aa =~ /VERSION\s+([\w\d\.]+)\s+/);
    ($org) = ($aa =~ /ORGANISM\s+(.+)/);
    ($ti) = ($aa =~ /db_xref=["']taxon:?(\d+)["']/);
    ($gi) = ($aa =~ /ACCESSION\s+(.*?)\s+/);
    ($pi) =($aa =~ /protein_id=["'](.*?)["']/);
    ($seq) = ($aa =~ /ORIGIN[^\n]*\n(.+)/s);
    chomp $seq; $seq =~ s/\d//g; $seq =~ s/\s//g;
    #$defline = "acc_$gi"."_gb_$vers"."_pi_$pi"."_locus_$locus"."_def_$defn";			
     $defline = "acc-$gi\|ti-$ti\|gb-$vers\|pi-$pi\|locus-$locus\|def-$defn";	
    
     #--------- copied from the subroutine extractGnB
    

    #New family added
    ($family)=($aa=~/ORGANISM(.*?)REFERENCE/gis);
     chomp $family; $family=~ s/\s//g; $family=~s/\;/\n\*/g;
     if($family=~m/\*(.*idae)/){
     $fam=$1;
     }
        
   #Initializations
    $cdseq = "";
    $fastaNtd="";
    $fastaAA="";
    %new_hash=();
    @gene=();
    my $count=1;
     
   #----------------------------------getting the gene list-------------------------------
    while($aa=~ /CDS\s+([\S\s]+?)\/gene=\"([\w+]+)\"[\s\S\n]+?translation=\"([\w\s]+)\"/g ){
    #      $seqcount=$seqcount+1;
    #    print "\nSequence Number $seqcount\n";
        $gene=$2;
        $new_hash{$count}=$gene;
        $sequence= $3;
        chomp $sequence;
        $sequence =~ s/\d//g; 
        $sequence =~ s/\s//g; #excluding the new line characters
        #        print ">\n$sequence\n";
        #       @gene=$gene;
        $count++;
        }
        #$count++;

       # print Dumper (\%new_hash);
   
   #---------------------------------------------------------------------------------------------


    while($aa=~/CDS\s+([\S\s]+?)\/[\s\S\n]+?translation=\"([\w\s]+)\"/g){ 
        $pos= $1;  #matches the position
        $cdseq= $2; #matches the aa sequence
          
        #NH modifying the sequence and excluding all the extra space 
        chomp $cdseq; 
        $cdseq =~ s/\s//g; #excluding the new line characters
        @new_array=(); # reseting the new array
        
        #NH modifying the position of the cds sequence
        chomp $pos;
        $pos=~ s/\s//g;
        $pos=~ s/join\((\S+)\)/$1/;
        $pos=~ s/complement//g;
        $pos=~ s/[><]//g;      
        $pos=~ s/\(/"\(/g;
        $pos=~ s/\)/\)"/g;
        
        #Using new array to store the position of the complement sequences which can be used to modify the nucleotide sequence
        @new_array=split(/"/,$pos); 
       # print "@new_array\n"; #now all the positions are saved in the array..
       
        
        $new_seq=""; 

        #now lets go through the array by line
        for $line(@new_array){
            if($line=~/^[\"\(]/){
               $complement =""; # used for reseting
                while($line=~/(\d+)\.\.(\d+)/g){
                    $start= $1;
                    $end=$2;
                    $cdslength= $end-$start+1;
                    # taking subset of the nucleotide seq at position mentioned
                    $subNtd= substr($seq, $start,$cdslength);
                    $complement=$complement . $subNtd;
                    }
                $trNtd= reverse($subNtd);
                $trNtd=~ tr/atcg/tagc/;
                $new_seq= $new_seq.$trNtd;
                }
            elsif($line=~/^[\d\,]/){
                while($line=~/(\d+)\.\.(\d+)/g){
                    $start= $1;
                    $end= $2;
                    $cdslength=$end-$start+1;
                    $subNtd= substr($seq,$start,$cdslength);
                    $new_seq= $new_seq . $subNtd;
                    }    
              
                }
            }
        

       $fastaNtd= $fastaNtd.">$defline\|pos-$pos\n$new_seq\n\n"; #extracts the ntd sequence if a complement is found and no complement is found accordingly
       #print $fastaNtd;
       $fastaAA= $fastaAA.">$defline\|pos-$pos\n$cdseq\n\n"; #extracts the aa sequence 
    }
    
return($gi,$ti,$org,$defn,$fastaNtd, $fastaAA,$fam); # NH return in the same order db_ref, cds sequence, position and the defline.....should also extract modified sequence with table 
}


        #gene=\"(\w+)\"\/[\s\S\n]+? translation=\"([\w\s]+)\"/g){ #  NH here $1 matched to the first bracket which specifies the position and $2 matches the second bracket that specifies the sequence


    #-----------------------------------------------------------------------------------------
                 #-------EXTRA------------------------------------  
                 #for(my $count=1; $count= length($gene);$count++)
                 #$gene
                 #print $gene."\n";
    
   #------------------------------------------------------------------------------------------
 
 
  #  %other_hash=();
  #  @protein=();
  #  $other_count=0;
    #-------------------getting the protein id ------------------------------------------------
  #  while($aa=~ /CDS\s+([\S\s]+?)\/[\s\S\n]+?protein_id=\"(\w+\d+\.+\d)\"/g){
   #     $other_count++;
    #    $protein=$2;
     #   $other_hash{$other_count}=$2;
     #   @protein=$protein;
      #  }
 
#    print Dumper(\%other_hash);
 



   #($db_ref)=($aa=~/db_xref=["']GI:?(\d+)["']/gis); #NH extracting the GI from CDS
   #($protein_id)= ($aa=~/protein_id=\"(\w+\d+\.+\d)\"/g);
   #($gene_name)= ($aa=~/gene=["'](\w+)["']/);
   #print ($gene_name);
   #print ($protein_id);




      #print "$pos\n";
       
        #$transeq=($aa=~/translation=["'](.*?)["']/s); #matches everything between " and " including the new line character
        #$cds= ($aa=~/CDS\s+([(\<|\w)+\.+(\,|(\w|\>))]+\w|)/);
        #print $db_ref;
        #print $transeq;


#        $aadefline= "gi||location|";
 #       $transeq=$cdseq ;
  #      $db_ref='';
   #     $seq_mod= $seq;
#        }
        #$db_ref=($aa=~/db_xref=["']GI:?(\d+)["']/); #NH extracting the GI from CDS
     
    #$defline = "gi|$gi|gb|$vers|$locus $defn";			
  
#-------------------------------------------------------------------------------------------------
#$r=length($new);
#print "Checking length:$r";
#$pos='';
#print my $aa[0];
#my $i = length($aa);
#print "length: $i\n";
#print "new sequence starts---------------------------------------------------";
#print $aa;   

#foreach my $new($aa){
#print "$new\n\n\n";
#return($db_ref, $transeq, $cds, $aadefline); 
#foreach my $line($new){
#print "lets check what is it";
#print $line;
#}

