#!/usr/bin/perl

# oai-explorer.pl - browse OAI repositories

# Eric Lease Morgan <emorgan@nd.edu>
# May 10, 2012 - first investigations; sorta brain dead


# configure; season to taste
use constant ROOT => 'http://content.library.luc.edu/cgi-bin/oai.exe';
use constant SET  => 'coll6';
use constant META => 'oai_dc';
#use constant ROOT => 'http://newspapers.bc.edu/cgi-bin/bostonsh-oaiserver';
#use constant SET  => 'bostonsh:BOSTONSH18930819-01-logical-sections';
#use constant META => 'gsdl_qdc';

# require
use Data::Dumper;
use Net::OAI::Harvester;
use strict;

# initialize
my $harvester = Net::OAI::Harvester->new( 'baseURL' => ROOT );
my $records   = $harvester->listRecords( metadataPrefix  => META, set => SET );
my $count     = 0;
binmode STDOUT, ":utf8";

# metadata formats
#my $list = $harvester->listMetadataFormats();
#print "archive supports metadata prefixes: ", join( ',', $list->prefixes ), "\n";
#exit;

# list sets
#my $sets = $harvester->listSets;
#foreach ( $sets->setSpecs ) {
#
#	print "  set spec: $_\n";
#	print "  set name: ", $sets->setName( $_ ), "\n";
#	print "\n";
#	
#}
#
## done
#exit;

# process each record
while ( my $record = $records->next ) {

	# increment
	$count++;
	
	# get the goodness
	my $header     = $record->header;
	my $identifier = $header->identifier;
	my $metadata   = $record->metadata;

	# (brute force) echo
	#print Dumper( $header ), "\n";
	#print Dumper( $metadata ), "\n";
		
	# (elegant) echo
	print "            item: $count\n";
	print "             key: $identifier\n";
	foreach ( $metadata->title ) { print "        title(s): $_\n" }
	foreach ( $metadata->identifier ) { print "   identifier(s): $_\n" }
	foreach ( $metadata->subject ) {    print "      subject(s): $_\n" }
	foreach my $description ( $metadata->description ) {
	
		$description =~ s/\W+/ /g;
		print "  description(s): $description\n";
		
	}
	print "            type: ", $metadata->type, "\n";
	print "\n";
	
	# poison pill
	#last if ( $count > 9 );

}

# done
exit;
