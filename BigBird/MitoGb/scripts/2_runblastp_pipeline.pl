#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
use Data::Dumper;


MAIN:{
    my $rh_opts = get_options();
    make_blastdb($rh_opts);
    run_blast($rh_opts);
    }

our $VERSION=0.1;

sub run_blast{
    my $rh_opts = shift;
    my $outfile = $rh_opts-> {'name'} .'.blastp';
    my $dbfile = $rh_opts-> {'name'}.'.db.fasta';
    my $gene_file = $rh_opts->{'genes'}; 
   # my $cmd = "blastp -outfmt 6 -query $gene_file -db $dbfile -out $outfile";  
   my $cmd = "blastp -outfmt 6 -query $gene_file -db $dbfile -max_target_seqs 5000 -out $outfile";  
    #print "$cmd\n"; 
    system($cmd);
}

sub make_blastdb {
    my $rh_opts = shift;
    my $inputdb = $rh_opts->{'inputdb'};
    my $outfile = $rh_opts-> {'name'} . '.db.fasta';
    my $null_file = $rh_opts ->{'name'} . '.null' ;
    my $cmd = "makeblastdb -in $inputdb -out $outfile -dbtype prot >$null_file";
  #  my $cmd = "makeblastdb -in $inputdb -out $outfile -dbtype nucl >$null_file";
    #print "$cmd\n";
    system($cmd);  
}


sub get_options {
    my $opt_version = '';
    my $opt_help    = '';
    my $opt_inputdb = '';
    my $opt_genes   = '';
    my $opt_name    = '';

    my $opt_results = Getopt::Long::GetOptions("version" => \$opt_version,
                                    "genes=s" => \$opt_genes,
                                           "name=s" => \$opt_name,
                                      "inputdb=s" => \$opt_inputdb,
                                             "help" => \$opt_help);
    usage() unless ($opt_results);
    die "$0 $VERSION\n" if ($opt_version);
    pod2usage({-exitval => 0, -verbose => 2}) if $opt_help;
    usage() unless ($opt_name);
    usage() unless ($opt_genes);
    usage() unless ($opt_inputdb);
    
    my %options = ('inputdb'  => $opt_inputdb,
                   'name'     => $opt_name,
                   'genes'    => $opt_genes);

    return \%options;
}

sub usage {
    die "$0 --name=NAME_FOR_OUTFILES --genes=GENES_FASTA --inputdb=INPUT_DATABASE_FASTA\n";
}


### --genes= Alignment file or gene sequence......
# --inputdb = Database of coding sequence fasta.....
#
###############################################################################################
#### Code Author: Natya Hans                                                             ######
###############################################################################################

