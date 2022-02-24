#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
use Data::Dumper;


MAIN: {
    my $rh_opts = get_options();
    get_profile($rh_opts);
    }

our $VERSION=0.1;

sub get_profile {
    my $rh_opts = shift;
 #   my $trimmed = $rh_opts->{'newalign'};  #open the new trimmed sequences created by the subroutine get_alignment 
    my $output = $rh_opts-> {'name'} . ".muscle.fasta";
    my $trimmed= $rh_opts-> {'name'};
    my $cmd = "muscle -in $trimmed -out $output";
   # my $cmd = "mafft --add $trimmed  --reorder $align >$output"; #this is faster
    #my $cmd = "mafft --add $trimmed --dpparttree  --reorder $align >$output"; #this is slower and for more than 20,000 sequences
    system ($cmd);
}

sub get_options {
    my $opt_version = '';
    my $opt_help    = '';
    # my $opt_newalign = '';
    #my $opt_oldalign   = '';
    my $opt_name    = '';

    my $opt_results = Getopt::Long::GetOptions("version" => \$opt_version,
                                    #"oldalign=s" => \$opt_oldalign,
                                           "name=s" => \$opt_name,
    #                                  "newalign=s" => \$opt_newalign,
                                             "help" => \$opt_help);
    usage() unless ($opt_results);
    die "$0 $VERSION\n" if ($opt_version);
    pod2usage({-exitval => 0, -verbose => 2}) if $opt_help;
    usage() unless ($opt_name);
    #usage() unless ($opt_oldalign);
    #usage() unless ($opt_newalign);
    
    my %options = (#'newalign'  => $opt_newalign,
                   'name'     => $opt_name);
     #              'oldalign'    => $opt_oldalign);

    return \%options;
}

sub usage {
    die "$0 --name=NAME_FOR_FILES_TO_ALIGN\n";
}


### --oldalign= Alignment file or gene sequence......
# --newalign = Database of coding sequence fasta.....
#
###############################################################################################
#### Code Author: Natya Hans                                                             ######
###############################################################################################





