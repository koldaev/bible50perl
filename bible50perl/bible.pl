#!/usr/bin/perl -w

use utf8;
use strict;
use autodie;
use open qw< IO :utf8 :std>;
use sigtrap qw< stack-trace normal-signals error-signals >;
use File::Basename;
no warnings 'uninitialized';

my $dirscript = dirname(__FILE__);

#if( length $ARGV[0] ) {
#    our $lang = $ARGV[0];
#} else {
#    our $lang = 'ru';
#}
#if( length $ARGV[1] ) {
#    our $book = $ARGV[1];
#} else {
#    our $book = 1;
#}

my $lang = $ARGV[0];
if (not defined $lang) {
    $lang = 'ru';
}
my $book = $ARGV[1];
if (not defined $book) {
    $book = 1;
}
my $chapter = $ARGV[2];
if (not defined $chapter) {
    $chapter = 1;
}

binmode(STDOUT, ":utf8");

open MORE, '|more' or die "unable to start pager";

#print MORE "hello $_!\n" for 1..1000;

my $filename = $dirscript.'/'.$lang.'/'.$book.'/bible_'.$lang.'_'.$book.'_'.$chapter.'.txt';
open(my $fh, $filename) or die "Could not open file '$filename' $!";
my $lines = "\n\n\n\n\n\n\n\n\n";
while (my $row = <$fh>) {
    $lines .= "$row\n";
}
print MORE $lines;

#open(my $fh, $filename) or die "Could not open file '$filename' $!";
#while (my $row = <$fh>) {
#    chomp $row;
#    print MORE "$row\n";
#}

