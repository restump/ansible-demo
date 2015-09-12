package MyApp::Movies;
use Mojo::Base 'Mojolicious::Controller';

use strict;
use warnings;

use Mango::BSON ':bson';


sub list {
	my $self = shift;
	my ($cursor, $fields, @rows);

	$cursor = $self->mango->db->collection('movies')->find;
	@rows = ( );

	while (my $document = $cursor->next) {
		push @rows, $document;
	}

	$self->render(json => \@rows);
}

sub create {
	my $self = shift;
	my ($info, $result);

	$info = $self->req->json;
	$result = $self->mango->db->collection('movies')->insert($info);

	$self->render(json => { insert => 1, oid => $result });
}

sub delete {
	my $self = shift;
	my ($oid, $result, $query, $options);

	$oid = Mango::BSON::ObjectID->new($self->req->json->{'oid'});
	$options = { single => 1 };
	$query	 = { _id => $oid };
	$result  = $self->mango->db->collection('movies')->remove($query, $options);

	$self->render(json => { delete => 1, oid => $oid });
}

1;
	
