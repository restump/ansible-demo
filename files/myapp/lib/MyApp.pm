package MyApp;
use Mojo::Base 'Mojolicious';

use Mango;
use Mojolicious::Plugins;

use lib 'lib';


sub startup {
	my $self = shift;
	my ($r, $api);

	$self->plugin('JSONConfig', { file => 'etc/MyApp.jsn' });
	$self->log(Mojo::Log->new(path => 'www.log', level => 'debug'));	
	$self->helper(mango => sub {
		my ($hostname, $database, $uri);

		$hostname = $self->app->config->{'database'}{'host'} || 'localhost';
		$database = $self->app->config->{'database'}{'name'} || 'development';

		$uri = "mongodb://$hostname:27017/$database";

		state $mango = Mango->new($uri);
		return $mango;
	});

	$r = $self->routes;
	$api = $r->any('/api')->to(namespace => 'MyApp');

	$api->get('/movies')->to(controller => 'Movies', action => 'list');
	$api->put('/movies')->to(controller => 'Movies', action => 'create');
	$api->delete('/movies')->to(controller => 'Movies', action => 'delete');

	$r->any('/*whatever' => { whatever => '' } => sub {
		my $c = shift;
		my $whatever = $c->param('whatever');
		$c->render(json => { 'error' => "/$whatever did not match." }, status => 404);
	});

}

1;
