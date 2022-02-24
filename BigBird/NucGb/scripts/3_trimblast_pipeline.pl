#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
use Data::Dumper;


MAIN: {
    my $rh_opts = get_options();
    get_alignment($rh_opts);
    }

our $VERSION=0.1;


sub get_alignment{
    my $rh_opts = shift; # getting the options
    

#-------------------------------------------- Initializations of hash
    # BLASTN
    my %orientation = ();  # *1hash*
    my %maxhash = ();      # *2hash*
    my %minhash =();       # *3hash*

    # TABLE
    my %acctaxahash = (); # *4hash*
    my %accfamhash = ();  # *5hash*
    my %titaxahash = ();  # *6hash*
    my %tifamhash = ();   # *7hash*
    my %tiacchash = ();   #### *13hash*
    
  
    # InputDB
    my %gihunthash =();   # *8hash*
    my %tihunthash =();   # *9hash*    

    # TRIM
    my %trimmedseqhash = (); # *10hash*
    my %lengthhash=();       # *11hash*

    # Output
    my %outhash=();          # *12hash*

# -----------------------------------Iniatlizations of vectors/scalar
   
    # BLASTN
    my $start = '';  # *1scalar
    my $end = '';    # *2scalar*
    my $gi='';       # *3scalar*
    my $ti= '' ;      # *4scalar*
  
    # TABLE
    my $tableacc = '';    # *5scalar* 
    my $tableti = '';     # *6scalar*
    my $tabletaxon = '';  # *7scalar*
    my $tablefam = '';    # *8scalar*

    # InputDB
    my $acchunt = '';     # *9scalar*
    my $sei = '';         # *10scalar*
    my $tihunt = '';       # *11scalar*
    my $ticaught = '';    # *12scalar*
    my $gihunt = '';      # *13scalar*
   
################################################################################################BLASTP 
    my $inputdb = $rh_opts->{'inputdb'};
    my @splitdb = split /\./,$inputdb;
    my $splittedb = $splitdb[0]; 
   
    my $blast_file = $rh_opts-> {'name'}.".". $splittedb . ".blastn";  
    open OUT, "$blast_file" or die "cannot open $blast_file:$!";
    while (my $line= <OUT>) {
        chomp $line;
        #print $line;
        my @fields = split /\t/,$line; # this has the first BLAST line split by tab
        
        # Extracting second column and getting acc number from it
        my $accession = $fields[1]; # second column has blast p results     
        my @extract = split /\|/, $accession; # since this is how we saved the blast p results too   
        my $extractgi = $extract[0];  # will have both acc and acc number
        my $extractti = $extract[1];  # will have both ti and ti number
        
        my @somegi = split /\-/,$extractgi; # split by - instead of _ because NCBI now has acc instead of gi which has _ in names
        $gi = $somegi[1];  # save the acc number    # *3scalar 

#        $gi = $extractgi;


        ### Let's extract the ti numbers too
        my @someti = split/\-/,$extractti;
        $ti = $someti[1];                         # *4scalar 
#        $ti = $extractti;
      
        $start = $fields[8]; # 9th column has start pos # *1scalar
        $end = $fields[9];   # 10th column has end pos  # *2scalar
        
        if($start<$end){  
            $orientation{$gi}="F";
	    if (! exists $minhash{$gi}){
                $minhash{$gi} = $start;
		$maxhash{$gi} = $end;
 	        }
	    else{
		if ($start < $minhash{$gi}){
		    $minhash{$gi} = $start;
		    }
		if ($end > $maxhash{$gi}){
		    $maxhash{$gi} = $end;
		    }	
	        }	
             }
         else{
            $orientation{$gi}="R";
	    if (! exists $minhash{$gi}){
                $minhash{$gi} = $start;
		$maxhash{$gi} = $end;
 	        }
	    else{
                if ($start > $minhash{$gi}){
		    $minhash{$gi} = $start;
		    }
		if ($end < $maxhash{$gi}){
		    $maxhash{$gi} = $end;
		    }	
                }
            }
        } 


#print "Hash1 for NH: Orientation\n";  ## *1hash*
#print Dumper \%orientation;
#print "Hash 2 for NH: Minimum \n\n";  # *2hash*
#print Dumper \%minhash; #prints the start postion
#print "Hash 3 for NH: Maximum \n\n"; # *3hash*
#print Dumper \%maxhash; #prints the end position*
#----------------------------------------------------------------------------------------------


########################################################################################################### TABLE FILE 

    my $table_file = $rh_opts->{'table'}; #picks out the table file 
    open OUTTABLE, "<$table_file" or die "cannot open $table_file:$!";
   
    while(my $tableline = <OUTTABLE>){
        chomp $tableline;
        my @tablefields = split /\|/, $tableline;   #split the table by | 

        my $tablesaveti = $tablefields[1];          #extract the second column that has ti nand ti number 
        my @saveti = split /\-/, $tablesaveti;      #split again by - to to extract the ti number
         $tableti =$saveti[1];                    #this has ti  # *6scalar
 #       $tableti=$tablesaveti;

      
        my $tablesaveacc = $tablefields[0];         # extract the first column that has acc and acc number
        my @saveacc = split /\-/,$tablesaveacc;     # split again by - to extract acc
         $tableacc= $saveacc[1];                  #this has acc # *5scalar
#        $tableacc=$tablesaveacc;
          
           $tablefam = $tablefields[2];             # this has family name from the table # *8scalar
           $tabletaxon = $tablefields[4];           # this has the taxon name from the original table split by | # *7scalar


        # Now saving it all in a hash
        $acctaxahash{$tableacc} = $tabletaxon;     # save acc as keys and taxa as values  in a hash table
        $accfamhash{$tableacc} = $tablefam; #  save acc as keys and family as values 
        
        $titaxahash{$tableti} = $tabletaxon;  # save ti as keys and and taxon names as values
        $tifamhash{$tableti} =$tablefam; # saves ti as keys and and family as values
        }

#print "Hash 4 Natya table that stores acc the and taxa";
#print Dumper \%acctaxahash; #prints acc as keys and taxa as values *4hash*

#print "Hash 5 Natya family that stores the acc and fam";
#print Dumper \%accfamhash; # print acc as keys and fam as values *5hash*
    
      
#print "Hash 6 Natya table hash that stores the ti and taxa";
#print Dumper \%titaxahash; #prints ti as key and taxa as values *6hash*


#print "Hash 7 Natya family hash that stores the ti and fam";
#print Dumper \%tifamhash; # prints ti as key and fam as values *7hash*

    

################################################################################################################### FASTA FILE/INPUTDB


    my $fasta_file = $rh_opts->{'inputdb'};        #access the original sequence file
    open OUTFASTA, "$fasta_file" or die "cannot open $fasta_file:$!";  #open the sequence file
    
    
    while(my $fastaline = <OUTFASTA>){           
        chomp $fastaline;
             
        if($fastaline=~ /^\>/){
            my $header= $fastaline;  
            my @headhunt = split /\|/,$header;
            $gihunt = $headhunt[0]; # this has acc and accnunberi *13scalar
            $tihunt = $headhunt[1]; # this has ti and ti number *11scalar
       
            my @headacchunt = split /\-/,$gihunt;
             $acchunt = $headacchunt[1];  # this has acc *9scalar
            # $acchunt=$gihunt;
         
             my @headtihunt = split /\-/,$tihunt;
             $ticaught = $headtihunt[1]; # this has ti  *12scalar
           # $ticaught=$tihunt;
            }     
        elsif($fastaline=~/[atcg]+/){ 
            $sei = $fastaline;  # this has sequence *10scalar
            }
 
        $gihunthash{$acchunt} = $sei; #saves all the gi and sequences
        $tihunthash{$ticaught} = $sei; #saves all the ti and sequences
        $tiacchash{$acchunt} = $ticaught; ### saves ti as keys and acc number as values
       } 

#print " Hash 8 Natya gihunthash stores the acc and sequences";
#print Dumper \%gihunthash; # prints acc as keys and sequence as values *8hash*

#print " Hash 9 Natya tihunthash stores the ti and sequences";
#print Dumper \%tihunthash; # prints ti as keys and sequence as values *9hash*


####################################################################################Trim the sequences obtained from the original database 
    
#   my $ohdebug = "debug.txt"; 

  #open OHDEBUG, ">$ohdebug" or die "cannot open $ohdebug:$!";
  for my $temper(keys %gihunthash){
            my $trimmedseq=0;
            my $length=0;
       #print OHDEBUG "$temper:this is temper\n"; 
       #print OHDEBUG "$gihunthash{$temper}: this should be sequence\n";
#        print OHDEBUG "$minhash{$temper}: this should be number\n";
       
        if (exists( $minhash{$temper})){
   #         print OHDEBUG "$temper:this is posttemper\n"; 
            my $sequencematch = $gihunthash{$temper};#contains the entire sequence
   #         print OHDEBUG "$sequencematch:this is seqmatch\n"; 
            
            my $first = $minhash{$temper};
            my $last  = $maxhash{$temper};
    #        print OHDEBUG "$first:this is first\n";
 
     #       print OHDEBUG "$last:this is last\n"; 
           
             if ($first>$last){
                my $new_first=$last;
                my $new_last =$first;
                $length = $new_last-$new_first+1;    
      #           print OHDEBUG "this is length\n$length\n"; # length check
                 if($length<4000 && $length >200){
                    $trimmedseq= substr($sequencematch,$new_first,$length);
                    $trimmedseq = reverse $trimmedseq;
                    $trimmedseq =~ tr/atcg/tagc/;
                    $trimmedseqhash{$temper}= $trimmedseq; # hash with trimmed sequence and gi 
       #           print OHDEBUG "this is trmieed seq$trimmedseq\n";
                    } 
                else{
                 #   print "nothing"; 
                    }
                }
      
            else{
                $length = $last-$first+1;
                if($length<4000 && $length >200){
                    $trimmedseq = substr($sequencematch, $first, $length);
                    $trimmedseqhash{$temper}= $trimmedseq; # hash with trimmed sequence and gi 
                    }
                else{
                    }
                }
           }  
        }
  # close OHDEBUG; 
             
#print "Hash 10 Natya keys: acc number and trimmed seq hash\n";
#print Dumper \%trimmedseqhash;  ### *9hash*
 
########################################################################################################################
#MAtching and output
#########################################################################################################################
# to match the trimmed seq and gi with gi and taxa hash (table hash)

    my $trimmed_output = $rh_opts->{'name'}.'.'.$splittedb.'.trimmed.fa';  #open output file for trimmed sequences
    open OUTTRIMMED, ">$trimmed_output" or die "cannot open $trimmed_output:$!";
    my $taxlist= $rh_opts->{'name'}.'.'.$splittedb.'.taxlist';
    open TAXONLIST, ">$taxlist" or die "cannot open $taxlist:$!"; 
    my $valtrimmedseq="";
    my $valtax="";
    my $valfamily="";
    my $checklength =0;
    my $valve="";
    my $defline="";
    my $gi_NH="";
    my $valti ="";
    foreach my $temp(keys %trimmedseqhash){
        if (exists($acctaxahash{$temp})){
            $valtrimmedseq = $trimmedseqhash{$temp}; ## this has the sequence
            $valfamily= $accfamhash{$temp};        ## this has family name
            $valtax = $acctaxahash{$temp}; ### this has taxa 
            $valti = $tiacchash{$temp};
            
            my @nex = split / /,$valtax; 
            if(!exists $nex[3]){
            $valve= join '|',$valfamily,@nex[0,1]; #has family and taxa too
            $gi_NH=$temp; #has acc number
            $defline="$valve\|"."$gi_NH\|"."$valti";
            $checklength = length($valtrimmedseq);
            $outhash{$defline}=$valtrimmedseq;
            $lengthhash{$valve}{$defline}= length($valtrimmedseq);
           }
       }
    }
#print "Hash 11 is length hash ans has no need to be printed";
#print "Hash 12 Natya out hash that saves deflines and sequences";
#print Dumper \%outhash;            # *10hash*
#----------------------------------------------------------------------------------------------------------------



########################################################################################################################NH#
##---This is printing out two things separate from the rest of the main and subalignment code------------------------------

############ Saving in the two file handles
# TAXONLIST - 
# AND OUTTRIMMED - has deflines and  trimmed sequences

while(my ($item, $hashref)=each %lengthhash){
    my ($longest)= sort {$hashref->{$b}<=> $hashref->{$a}} keys %$hashref;
     #print "$item :$longest\n"; #this prints out the key with the longest value
     print TAXONLIST "$item\n";
     print OUTTRIMMED ">$longest\n$outhash{$longest}\n\n";
     }  
}
close OUTTRIMMED;
# this is where the subalignment subroutine ends
############################################################################################################################ 


#############################################################################################################################
#######################################Options############################################################################NH#
#############################################################################################################################
### the main skeleton of the script
sub get_options {
    my $opt_version = '';
    my $opt_help    = '';
    my $opt_inputdb = '';
    my $opt_table   = '';
    my $opt_name    = '';

    my $opt_results = Getopt::Long::GetOptions("version" => \$opt_version,
                                    "table=s" => \$opt_table,
                                           "name=s" => \$opt_name,
                                      "inputdb=s" => \$opt_inputdb,
                                             "help" => \$opt_help);
    usage() unless ($opt_results);
    die "$0 $VERSION\n" if ($opt_version);
    pod2usage({-exitval => 0, -verbose => 2}) if $opt_help;
    usage() unless ($opt_name);
    usage() unless ($opt_table);
    usage() unless ($opt_inputdb);
    
    my %options = ('inputdb'  => $opt_inputdb,
                   'name'     => $opt_name,
                   'table'    => $opt_table);

    return \%options;
}

#-----
### The usage will pop up 

sub usage {
    die "$0 --name=NAME_FOR_BLASTNOUTPUT_FROM_PREVIOUS_BLAST --table=NAME_OF_TABLEFILE --inputdb=INPUT_DATABASE_FASTA\n";
}
###############################################################################################################################
######################
# Usage of the above script 
# 
# --table= table generated from the original genbank to fasta code......
# --inputdb = Database of coding sequence fasta.....
#
###################################################################################################
#### Code Author: Natya Hans                                                                    ###
# *********************************NOTE*****************************                           ###################################################################################################
