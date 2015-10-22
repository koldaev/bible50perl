#!/usr/bin/perl -w
require './mysql_connect.pl';

my @biblelangarray = ('ru','en','de','es','fr','it','gr','pt','tr','zh','ara','heb','hin','jap','ko','tam','du','vi','hu','th','da','ro','ur','fa','bn','sv','no','fi','cs','sq','be','uk','bg','hr','kk','ka','hy','lv','et','lt','pl','mk','sr','sk','is','am','af','sw','la','tl');

my $i=0;
while($i<@biblelangarray) {

    my $langdirectory = $biblelangarray[$i];

    unless (-e $langdirectory or mkdir $langdirectory) {
        die "Unable to create $langdirectory\n";
    }

    my $bible = 1;
    while($bible <= 66) {

        my $directory = $langdirectory."/".$bible;

        unless (-e $directory or mkdir $directory) {
            die "Unable to create $directory\n";
        }

        my $biblenametable = $langdirectory.'bible';
        my $ch = $dbh->prepare(qq{SELECT chapters from $biblenametable where idbible = $bible});
        $ch->execute();
        my $biblechapters = $ch->fetchrow_array();

        $ch->finish();

        my $poem = 1;
        while ($poem <= $biblechapters)
        {

            my $textname =  $langdirectory.'text';
            my $sth = $dbh->prepare(qq{SELECT poem, poemtext FROM $textname where bible = $bible and chapter = $poem});
            $sth->execute();

            my $filenamebible = $directory."/bible_".$langdirectory."_".$bible."_".$poem.".txt";
            open WRITEFILE, ">$filenamebible" or die "Cannot write to $filenamebible!\n";

            while (my ($poem, $poemtext) = $sth->fetchrow_array())
            {
                chomp($langdirectory);
                if($langdirectory eq "en") {
                    print WRITEFILE $poem." ".$poemtext."\n";
                } else {
                    if (utf8::is_utf8($poemtext)) {
                        utf8::encode($poemtext);
                        print WRITEFILE $poem." ".$poemtext."\n";
                    } else {
                        print WRITEFILE $poem." ".$poemtext."\n";
                    }
                }
            }
            $sth->finish();

            close(WRITEFILE);

            $poem++;

        }

        $bible++;

    }

    print "bible on ".$langdirectory." created\n";
    $i++;

}

$dbh->disconnect();
