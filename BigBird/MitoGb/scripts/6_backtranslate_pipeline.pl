#!/usr/bin/perl 

#To call the script :  perl script DNA_seqeuence_file aa_alignment_file 
# This script is part of the G. Burleigh Tree of Everything pipeline.  Written by A.C. Payton. 
# Modified by NH Dec 2017

# Dependencies:
# assumes the name of the DNA sequence and the AA sequence are identical. 
# assumes that the fasta file containing the DNA sequences has the sequences all on one line.
# The AA alignment file can be wrapped, or not, it does not matter.  


$dna_file = $ARGV[0];
$file_ext = $ARGV[1];
@file_array = glob ("*$file_ext");

%geneticcode =
    (
    'TCA' => 'S', # serine
    'TCC' => 'S', # serine
    'TCG' => 'S', # serine
    'TCT' => 'S', # serine
    'TCN' => 'S', # serine
    
    
    'TTC' => 'F', # phenylalanine
    'TTT' => 'F', # phenylalanine
    'TTA' => 'L', # leucine
    'TTG' => 'L', # leucine
    'TAC' => 'Y', # tyrosine
    'TAT' => 'Y', # tyrosine
    'TAA' => '*', # stop
    'TAG' => '*', # stop
    'TGC' => 'C', # cysteine
    'TGT' => 'C', # cysteine
    'TGA' => '*', # stop
    'TGG' => 'W', # tryptophan
    
    'CTA' => 'L', # leucine
    'CTC' => 'L', # leucine
    'CTG' => 'L', # leucine
    'CTT' => 'L', # leucine
    'CTN' => 'L', # leucine
    
    
    'CCA' => 'P', # proline
    'CCC' => 'P', # proline
    'CCG' => 'P', # proline
    'CCT' => 'P', # proline
    'CCN' => 'P', # proline
    
    'CAC' => 'H', # histidine
    'CAT' => 'H', # histidine
    'CAA' => 'Q', # glutamine
    'CAG' => 'Q', # glutamine
    
    'CGA' => 'R', # arginine
    'CGC' => 'R', # arginine
    'CGG' => 'R', # arginine
    'CGT' => 'R', # arginine
    'CGN' => 'R', # arginine
    
    
    'ATA' => 'I', # isoleucine
    'ATC' => 'I', # isoleucine
    'ATT' => 'I', # isoleucine
    'ATG' => 'M', # methionine
    
    'ACA' => 'T', # threonine
    'ACC' => 'T', # threonine
    'ACG' => 'T', # threonine
    'ACT' => 'T', # threonine
    'ACN' => 'T', # threonine
    
    
    'AAC' => 'N', # asparagine
    'AAT' => 'N', # asparagine
    'AAA' => 'K', # lysine
    'AAG' => 'K', # lysine
    'AGC' => 'S', # serine
    'AGT' => 'S', # serine
    'AGA' => 'R', # arginine
    'AGG' => 'R', # arginine
    
    'GTA' => 'V', # valine
    'GTC' => 'V', # valine
    'GTG' => 'V', # valine
    'GTT' => 'V', # valine
    'GTN' => 'V', # valine
    
    
    'GCA' => 'A', # alanine
    'GCC' => 'A', # alanine
    'GCG' => 'A', # alanine
    'GCT' => 'A', # alanine
    'GCN' => 'A', # alanine
    
    'GAC' => 'D', # aspartic acid
    'GAT' => 'D', # aspartic acid
    'GAA' => 'E', # glutamic acid
    'GAG' => 'E', # glutamic acid
    
    'GGA' => 'G', # glycine
    'GGC' => 'G', # glycine
    'GGG' => 'G', # glycine
    'GGT' => 'G', # glycine
    'GGN' => 'G', # glycine
    
    'NNN' => 'X', # true gaps	
    );

###################################################
##                                               ## 
##    SECTION 1: Storing the Coding Sequences    ##
##                                               ##
###################################################

# open the file containing the coding sequences for all species
# and store them in a giant hash table

open IN, "<$dna_file" or die "$dna_file not found \n\n";
%dnahash=();
$dnaseqcounter = 0;
while (<IN>){
    $line = $_;
    if ($line =~ /^>([\S\s]+)/){ #Matching header line in fasta file
        $name = $1;
	chomp $name;
	$nextline = <IN>;
	chomp $nextline;
	$nextline = uc $nextline;
	$dnahash{$name} = $nextline;
        $dnaseqcounter ++;
        }
    }
print "\n$dnaseqcounter DNA sequences loaded into memory\n"; 
close IN;

###################################################
##                                               ## 
##    SECTION 2: Back-Translating AA Alignments  ##
##                                               ##
###################################################

## This one is complicated, but it finds the DNA sequence for each individual in the AA alignement
# It then tries to translate that DNA sequence starting at the first base, then if it fails the second base, and finally if it fails the third base.
# If the script can match the genbank AA sequence to a particular frames in the DNA sequence it then back translates the AA alignment into nucleotides 
# Using the original DNA sequence.  

system "mkdir aa_to_nuc3"; # this can be done sigh

open LOG, ">aa_to_nuc3/back_translate_error_log.txt";

for $file (@file_array){
    open OUT, ">aa_to_nuc3/$file\.aa_to_nuc3\.fasta";
    open IN2, "<$file";
    $/=">";		
    while (<IN2>){
        $line = $_;
	#print "LINE: $line\n";
	if($line =~ /(\S+)\n([\S\s]+)/){ #Matching header line in AA alignment fasta file 
	    $name = $1;
	    #print "NAME: $name\n";
	    $aa_align = $2;
	    $aa_align =~ s/\n//g;
	    $aa_align =~ s/>//g;
	    #print "AA: $aa_align\n";
	    #print "gap: $aa_align";
	    $aa_align_nogap = $aa_align;
	    $aa_align_nogap =~ s/-//g;
	    $bait = substr ($aa_align_nogap, 0, 12);
            #change the length of this substr if you want a shote or longer AA sequence u
            #used to match against the translated DNA to identify the starting point for the AA sequence.  
            # NOTE IF YOU CHANGE THIS YOU ALSO HAVE TO CHANGE THE MISMATCH THRESHOLD 	$threshold
	    if(exists $dnahash{$name}){
                $dna_seq = $dnahash{$name};
                #print "$dna_seq\n";
                #$reversedna_seq= reverse $dna_seq;
                #print "$reversedna_seq\n\n\n\n";
		#pass DNA seq to sub translate
		($extracted_dna, $kill_switch) = translate($dna_seq, $bait); # Call the translate subroutine
		if($kill_switch == 0){	#kill switch #1 :
                    #If active ( =1 ) then no perfect matches could be found between the AA bait and the translated DNA, sequence is then passed to subrouting last_resort.
		    #pass to sub to find start of AA seq and return trimmed DNAseq
		    ($aligned_dna, $name, $kill_switch) = backtranslator($aa_align, $extracted_dna, $name);
	            if($kill_switch == 0){ # kill switch #2
		        print OUT ">$name\n$aligned_dna\n";
                        }
		    else{
                       # print "Codon error: $name in alignemnt $file may have experienced a frameshift and was excluded\n";	
		         print LOG ">$file|frame shift|$name\n\n";	
	##	#	 print LOG "Codon error: $name in alignment $file may have experienced a frameshift and was excluded\n";
			}
		    }
		else{
                    $reversedna_seq=reverse $dna_seq;
                    ($extracted_dna, $kill_switch) = translate($reversedna_seq, $bait); # Call the translate subroutine
		    if($kill_switch == 0){	#kill switch #1  
                        #If active ( =1 ) then no perfect matches could be found between the AA bait and the translated DNA, sequence is then passed to subrouting last_resort.
		        #pass to sub to find start of AA seq and return trimmed DNAseq
		        ($aligned_dna, $name, $kill_switch) = backtranslator($aa_align, $extracted_dna, $name);
	                if($kill_switch == 0){ # kill switch #2
		            print OUT ">$name\n$aligned_dna\n";
                            }
		        else{
                           #  print "Codon error: $name in alignemnt $file may have experienced a frameshift and was excluded\n";	
		             print LOG ">$file|frame shift|$name\n\n";	
	##	#	     print LOG "Codon error: $name in alignment $file may have experienced a frameshift and was excluded\n";
		           }
		       }
               	#This else loop is executed when the above IF block fails to find a perfect match this looks for imperfect matches
	            else{
                        ($extracted_dna, $name, $kill_switch) = last_resort ($dna_seq, $bait, $name);
		        if($kill_switch == 0){	
		           ($aligned_dna, $name, $kill_switch) = backtranslator ($aa_align, $extracted_dna, $name);
		            if ($kill_switch == 0){
                                print OUT ">$name\n$aligned_dna\n";
		                #print "Mismatch warning: $name was successfully translated but contains at least 1 mismatch between the AA sequence and the translated DNA seqence";
		                }
		            else{
                                #print "Codon error: $name in alignemnt $file may have experienced a frameshift and was excluded\n";	
		                #print LOG "Codon error: $name in alignemnt $file may have experienced a frameshift and was excluded\n";
		                print LOG ">$file|frame shift|$name\n\n";	
		                }
		            }
	                else{
                             ($extracted_dna, $name, $kill_switch) = last_resort($reversedna_seq, $bait, $name);
		             if($kill_switch == 0){	
		                 ($aligned_dna, $name, $kill_switch) = backtranslator ($aa_align, $extracted_dna, $name);
		                 if ($kill_switch == 0){
                                     print OUT ">$name\n$aligned_dna\n";
		                     #print "Reverse warning for $name\n";
		                     }
		                 else{
		                     print LOG ">$file|reverse shift|$name\n\n";	
		                     }
		                 }
                              else{
		                  print LOG ">$file|failure|$name\n\n";
		                  }	
		             }
                        }
		    }
	        }	
            }
        }
    close IN2;
    }

close OUT;
close LOG;
%dnahash=();


sub translate{
    #print"\nexecuting sub translate\n";
    $dna = shift (@_);
    $bait = shift (@_);
    #print "dna:$dna\naa_aligned\n$bait\n";
    ##Turn on to check if variable is being bassed to subroutine
    $dnalength = length $dna;
    $aalength = length $aa_align_nogap;	#WHAT IS THIS VARIABLE DOING AND WHAT DOES EXTRACTOR NEED WITH IT!!
    $codonnum1 = int ($dnalength / 3);
    $codonnum2 = int (($dnalength -1 ) / 3);
    $codonnum3 = int (($dnalength -2) / 3);
    $aa = "";
    $start = 0;
    $kill_switch = 0;
    for(0 .. ($codonnum1 - 1)){
        $dna1= $dna;
	$codon = substr ($dna1, $start, 3);
	$start = $start + 3;
	if(exists $geneticcode{$codon}){
	    $aa = $aa . $geneticcode{$codon};
            }
	else{
            $aa = $aa . "X";
            }
	}
        $dna_translated1 = $aa;
	#print"DNA_translated1\n$dna_translated1\n";
	($go_no_go, $extracted_dna) = extractor ($dna_translated1, $bait, $dna1, $aalength);			
	#print "Go_no_go 1\n$go_no_go\n";
	
        if($go_no_go == 1){
	    #print "FOUND Correct frame on first try\n";
	    return ($extracted_dna, $kill_switch);
            }
        #Go around again 2		
	else{
            #print "GOING AROUND AGAIN 2\n";
	    $dna2 = substr ($dna, 1, ($dna_length -1));
	    $aa = "";
            $start = 0;
            for(0 .. ($codonnum2 - 1)){
                $codon2 = substr ($dna2, $start, 3);
		$start = $start + 3;
		if(exists $geneticcode{$codon2}){
		    $aa = $aa . $geneticcode{$codon2};
                    }
		else{
                    $aa = $aa . "X";
                    }
		}
	    $dna_translated2 = $aa;
	    #print"DNA_translated\n$dna_translated2\n";
	    ($go_no_go, $extracted_dna) = extractor ($dna_translated2, $bait, $dna2, $aalength);	
	    }
	 #print "GO_no_go 2\n$go_no_go\n";
	

	if ($go_no_go == 1){
	    #print "FOUND Correct frame on second try\n";
	    return ($extracted_dna, $kill_switch);
            }

        #Go around again 3			
        else {
            #print "GOING AROUND AGAIN 3\n";
	    $dna3 = substr ($dna, 2, ($dna_length - 2));
	    $aa = "";
            $start = 0;
	    #print "original dna:\n$dna\n";
	    #print "DNA3\n$dna3\n";
	    for(0 .. ($codonnum3 - 1)){
	        $codon3 = substr ($dna3, $start, 3);
		$start = $start + 3;
		if (exists $geneticcode{$codon3}){
		    $aa = $aa . $geneticcode{$codon3};
                    }
		else{
                    $aa = $aa . "X";
                    }
		}
            $dna_translated3 = $aa;
	    #print"DNA_translated3\n$dna_translated3\n";
	    ($go_no_go, $extracted_dna) = extractor ($dna_translated3, $bait, $dna3, $aalength);	
	    }
	#print "GO_no_go 3\n$go_no_go\n";	
	

        if ($go_no_go == 1){
	    #print "FOUND Correct frame on third try\n";
	    return ($extracted_dna, $kill_switch);
            }
	else{
            $kill_switch = 1; 
            return ($extracted_dna, $kill_switch)
            }
       }			


sub extractor{
    #print "executing extractor\n";
    $dna_translated = shift (@_);
    $bait = shift (@_);
    $sub_dna = shift (@_);
    $length_aa = shift (@_);		#	THIS MAY NOT BE NECESSARY !!!!
    #print "DNA:\n$sub_dna\ntranslated dna\n$dna_translated\nbait\n$bait\n";
    $startpos = index ($dna_translated, $bait);
    #print"Start pos:\n$startpos\n";
    if ($startpos == -1){
        $go_no_go = 0;
        $extracted_dna = "";
	return ($go_no_go, $extracted_dna);
	}
    else {
        $extracted_dna = substr ($sub_dna, ($startpos * 3));
	$go_no_go = 1;
	return ($go_no_go, $extracted_dna);
	}
    }


sub backtranslator{
    #print "Executing sub backtanslator\n";
    $aligned_dna = "";
    $aa_align = shift (@_);
    $extracted_dna = shift (@_);
    $name = shift (@_);
    #print "DNA:$extracted_dna\n";
    #print "AA_alignment\n$aa_align\n";
    @temp_aa_seq = ();
    @temp_dna_seq = ();
    $mismatchcounter = 0;
    $kill_switch = 0;
    @temp_aa_seq = split (//, $aa_align);
    @temp_dna_seq = ($extracted_dna =~ m/.../g);
    #print "aa:\n@temp_aa_seq\n";
    #print "dna:\n@temp_dna_seq\n";
    foreach (@temp_aa_seq){
        $aa = $_;
	if ($aa eq "-"){
            $aligned_dna = $aligned_dna . "---";
            }
	else {
            $codon = shift (@temp_dna_seq);
	    #print "$codon\, ";
	    if ($codon ne ""){
                $translation = $geneticcode{$codon};	#translates dna into aa to check that it matches what is in the AA alignment 
		if ($translation eq $aa){
                    $aligned_dna = $aligned_dna . $codon;
                    }
		else{
                    #$aligned_dna = $aligned_dna . "XXX";#This was removed
		    $aligned_dna = $aligned_dna . $codon;
                    #This returns whatever codon is in the DNA sequence even if it does not translate to the AA that we see in the alignment
		    $mismatchcounter ++;
                    #This keeps track of the number of times there is a mismatch between the DNA sequence and the AA sequence.  It will be used to help identify frame shift mutations.	
		    }			
		}
	    else{
                $aligned_dna = $aligned_dna . "---";
                }
	    }
	}				
    #print "$name\t$mismatchcounter\n";
    #print "aligned DNA\n$aligned_dna\nextractedDNA:\n$extracted_dna\nAA_align\n$aa_align\n";
    if ($mismatchcounter >= (((length $extracted_dna) /3) * 0.333)){
        #This asks if the number of codons that did not match the AA in the alignment is greater than 1/3 of the total DNA sequence.  If it is that sequence is thrown out via the kill_switch function.
	$kill_switch = 1; return ($aligned_dna, $name, $kill_switch);
        }
    else{
        return ($aligned_dna, $name, $kill_switch);
        }

}	
	


sub last_resort{		
#large portions of this are direct copies of subrouting translate, except the subrouting imperfect_match is used instead of the subroutine extractor.
#print "executing last_resort\n";
    $dna = shift (@_);
    $bait = shift (@_);
    $name = shift (@_);
    #print "DNA:\n$dna\nBait:\n$bait\n";
    $dna1 = "";
    $dna2 = "";
    $dna3 = "";	#clearing out variables probably unnecessarily.
    $dnalength = length $dna;
    $codonnum1 = int ($dnalength / 3);
    $codonnum2 = int (($dnalength -1 ) / 3);
    $codonnum3 = int (($dnalength -2) / 3);
    $aa = "";
    $start = 0;
    $kill_switch = 0;
    for (0 .. ($codonnum1 - 1)){
        $dna1= $dna;
	$codon = substr ($dna1, $start, 3);
	$start = $start + 3;
	if (exists $geneticcode{$codon}){
	    $aa = $aa . $geneticcode{$codon};
            }
	else {
            $aa = $aa . "X";
            }
	}
    $dna_translated1 = $aa;
    #print"DNA_translated1\n$dna_translated1\n";
    ($go_no_go, $extracted_dna) = imperfect_match ($dna_translated1, $bait, $dna1);			
    #print "Go_no_go 1\n$go_no_go\n";
    
 
    if ($go_no_go == 1){
        #print "FOUND Correct frame on first try\n";
	#print "extracted dna:\n$extracted_dna\n";
	return ($extracted_dna, $name, $kill_switch);
	}
    #Go around again 2		
    else{
        #print "GOING AROUND AGAIN 2\n\n";
	$dna2 = substr ($dna, 1, ($dna_length -1));
	#print "original dna\n$dna\ndna2:\n$dna2\n";
	$aa = "";
        $start = 0;
	for (0 .. ($codonnum2 - 1)){
            $codon2 = substr ($dna2, $start, 3);
	    $start = $start + 3;
	    if (exists $geneticcode{$codon2}){
	        $aa = $aa . $geneticcode{$codon2};
                }
	    else{
                $aa = $aa . "X";
                }
	    }
	$dna_translated2 = $aa;
	#print"DNA_translated\n$dna_translated2\n";
	($go_no_go, $extracted_dna) = imperfect_match ($dna_translated2, $bait, $dna2);	
	}
    #print "GO_no_go 2\n$go_no_go\n";
	

	
    if ($go_no_go == 1){
        #print "FOUND Correct frame on second try\n";
        return ($extracted_dna, $name, $kill_switch);
        }
    #Go around again 3			
    else{	
        #print "GOING AROUND AGAIN 3\n\n";
	$dna3 = substr ($dna, 2, ($dna_length - 2));
	#print "original dna\n$dna\ndna3:\n$dna3\n";
	$aa = "";
        $start = 0;
	#print "dan:\n$dna\n";
	#print "DNA3\n$dna3\n";
	for (0 .. ($codonnum3 - 1)){
	    $codon3 = substr ($dna3, $start, 3);
	    $start = $start + 3;
	    if (exists $geneticcode{$codon3}){
	        $aa = $aa . $geneticcode{$codon3};
                }
	    else{
                $aa = $aa . "X";
                }
	    }
	$dna_translated3 = $aa;
	#print"DNA_translated3\n$dna_translated3\n";
	($go_no_go, $extracted_dna) = imperfect_match ($dna_translated3, $bait, $dna3);	
	}
    #print "GO_no_go 3\n$go_no_go\n";	

    if ($go_no_go == 1){
        #print "FOUND Correct frame on third try\n";
	return ($extracted_dna, $name, $kill_switch);
        }
    else{
        $kill_switch = 1; return ($extracted_dna, $name, $kill_switch)
        }
}

## another subroutine
sub imperfect_match {
    #print "executing imperfect_match sub\n";
    $dna_translated = shift (@_);
    $bait = shift (@_);
    $dna_substr = shift (@_);
    #print "Dna translated:\n$dna_translated\nBait:\n$bait\ndna sequence:\n$dna_substr\n";
    $threshold = "9";	#Change this if you want to allow more mismatches, bait length is currently set at 15. 
    $num_codons = int ((length $dna_substr) / 3);
    #print "num condons:\n$num_codons\n";
    $start = 0;
    @bait_array =();
    @bait_array = split (//, $bait);
    #print "bait array:\n@bait_array\n";
    $go_no_go = 0;
    
    #begin sliding window
    for (0.. ($num_codons - 1)){
        #print "in for loop\n";
        if ($go_no_go == 0){
	    #print "executing sliding window\n"; 
	    @window_array = ();	#resets array every time the window slides.
	    $dna_window = substr ($dna_translated, $start, 12);
	    @window_array = split (//, $dna_window);
	    #print "window array:\n@window_array\n";
	    $position = 0; #keeps track of the number of the place in the array as it travels through the for loop of the window_array
	    $matchcounter = 0;	#keeps track of the number of AA matches between the translated dna and the bait
            foreach (@window_array){
                #print "window $position\t$window_array[$position]\nbait $position\t$bait_array[$position]\n";
		if ($window_array[$position] eq $bait_array [$position]){
		    $matchcounter++;
                    }
		$position++;
		}			
	    if ($matchcounter >= $threshold){
                #print "Found match with $matchcounter matches, starting at $start\n";
	        $go_no_go =1;
	        $extracted_dna = substr ($dna_substr, ($start * 3));	
	        return ($go_no_go, $extracted_dna);
	        }
	    else{ 
                $start++;
                }
	    }
	}	
	
    if ($go_no_go == 0){
        $extracted_dna = "";
        return ($go_no_go, $extracted_dna);
	}
}

	
