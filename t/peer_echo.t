use Test::Base;

plan tests => 9;

use Test::TCP;
use AnyEvent::JSONRPC::TCP::Peer;
use AnyEvent::JSONRPC::TCP::Listener;

my $port = empty_port;

## server
my $server = AnyEvent::JSONRPC::TCP::Listener->new( port => $port );
ok( $server, "Server created");
my $cbreg = $server->reg_cb(
    echo => sub {
        my ($result_cv, @params) = @_;
        ok($result_cv, "Echo called ok");
        is_deeply({ foo => 'bar' }, $params[0], 'echo param ok');
        $result_cv->result(@params);
    }
);
ok( $cbreg, "Server Callback Registered");
ok( $server->method('echo'), 'Server has echo callback' );
ok( ! $server->method('foo'), 'Server has no foo callback' );

# client;
my $client = AnyEvent::JSONRPC::TCP::Peer->new(
    host => '127.0.0.1',
    port => $port,
    version => '1.0',
);
ok( $client, "Client created");

my $res = $client->call( echo => { foo => 'bar' } )->recv;
ok( $res, "Client received response from server");

is_deeply({ foo => 'bar' }, $res, 'echo response ok');

