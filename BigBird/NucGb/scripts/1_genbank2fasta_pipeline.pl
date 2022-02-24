#!/usr/bin/perl -w

# script to read a genbank flatfile and store information
# input: 
#	1.  flatfile, genbank format, of all records under consideration 
#	2.  criteria (initialized variables) for retaining records.
# output:
#	1.  flatfile, genbank format, culled to specifications (e.g., by size of seq)
#	2.  fasta file, containing same records as in culled flatfile, with fasta deflines as per NCBI:
#		gi|ginumber|db|accession|locus where db should be replaced by, e.g., gb or emb. 
#	3.  table of gis, tax id numbers, seq lengths, organism names, putative products.
# dependencies:
#	1.  record separator must be // and first line of record must be standard
#	2.  assumes that there are no headers (although if there are, there should be no problem).
#		(Headers are the several lines at the beginning of the genbank flatfiles
#		indicating date of release, etc.)


# ----- initializations ---------------------------------------------------------------------------

$infile = $ARGV[0];
$outfile = $ARGV[1];
$culledfile ="$outfile.gnb";
$fastafile = "$outfile.fasta";
$tablefile = "$outfile.table";

die ("Missing input file\n") if (!(-e $infile));
die ("Output file(s) $culledfile, $fastafile, or $tablefile already exist\n") if ((-e $culledfile) || (-e $fastafile) || (-e $tablefile));

$sizeCriterion = 1000000;
$moleculeCriterion = "DNA";

$accepted=0;
$notDNA=0;
$DNAbutTooBig=0;
$totalEvaluated=0;

# ----- read genbank flatfile, select records to include, make new files --------------------------

open FH1, "<$infile";
open FH2, ">$culledfile";
open FH3, ">$fastafile";
open FH4, ">$tablefile";

$/="\n//\n";
while (<FH1>) 
	{
	$record = $_;
	if ($record =~ /LOCUS\s+\w+\s+(\d+)\sbp.+\b$moleculeCriterion\b/)
		{
		$length = $1;
		if ($length <= $sizeCriterion)
			{
			($gid, $tid, $taxon, $product, $defline, $sequence, $fam) = (&extractGnb($record));
			if (! exists $taxonHash{$taxon})
				{$taxonHash{$taxon} = ($tid);}
			print FH2 "$record";							# add to new culled genbank file
			print FH3 ">$defline\n$sequence\n\n";					# add to fasta file
                        print FH4 "acc-$gid\|ti-$tid\|$fam\|$length\|$taxon\|$product\n";    # add to translation table
			++$accepted;
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

die ("doesn't add up") if (! $totalEvaluated == ($accepted+$notDNA+$DNAbutTooBig));
print "total\tnot DNA\tlarge DNA\taccepted\n$totalEvaluated\t$notDNA\t$DNAbutTooBig\t$accepted\n";

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
#print $org;
($ti) = ($gnb =~ /db_xref=["']taxon:(\d+)["']/);
($seq) = ($gnb =~ /ORIGIN[^\n]*\n(.+)/s);
chomp $seq; $seq =~ s/\d//g; $seq =~ s/\s//g;
$defline = "acc-$gi\|ti-$ti\|gb-$vers\|locus-$locus\|def$defn";
($family)=($gnb=~/ORGANISM(.*?)REFERENCE/gis);
chomp $family; $family=~ s/\s//g; $family=~s/\;/\n\*/g;
if($family=~m/\*(.*idae)/){
$fam=$1;
}
return ($gi, $ti, $org, $defn, $defline, $seq,$fam);

}

####################################################################################################################################
# To run the code, provide infile(Genbank file) as first argument[0] and the name outfile to be generated as the second argument[1]
# 
####################################################################################################################################
