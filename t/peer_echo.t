use Test::Base;

plan tests => 16;

use Test::TCP;
use AnyEvent::JSONRPC::TCP::Peer;
use AnyEvent::JSONRPC::TCP::Listener;

BEGIN { require 'sub_x.pm' };

my $port = empty_port;

## server
my $server = AnyEvent::JSONRPC::TCP::Listener->new(
  port => $port,
  version => '1.0',
);
ok( $server, "Server created");
my $scbreg = $server->reg_cb(
    echo => sub {
        my ($result_cv, @params) = @_;
        ok($result_cv, "Echo called ok");
        #use Data::Dumper;
        #warn Data::Dumper->Dump(\@params, ["*** echo params"]);
        is_deeply({ foo => 'bar' }, $params[0], 'echo param ok');
        $result_cv->result(@params);
    }
);
ok( $scbreg, "Server Callback Registered");
ok( $server->method('echo'), 'Server has echo callback' );
ok( ! $server->method('foo'), 'Server has no foo callback' );

# client;
my $client = AnyEvent::JSONRPC::TCP::Peer->new(
    host => '127.0.0.1',
    port => $port,
    version => '1.0',
);
ok( $client, "Client created");
my $ccbreg = $client->reg_cb(
    echo => sub {
        my ($result_cv, @params) = @_;
        ok($result_cv, "Echo called ok");
        #use Data::Dumper;
        #warn Data::Dumper->Dump(\@params, ["*** echo params"]);
        is_deeply({ foo => 'bar' }, $params[0], 'echo param ok');
        $result_cv->result(@params);
    }
);
ok( $ccbreg, "Client Callback Registered");
ok( $client->method('echo'), 'Client has echo callback' );
ok( ! $client->method('foo'), 'Client has no foo callback' );

# Let client send echo to server and wait for response
my $cres = $client->call( echo => { foo => 'bar' } )->recv;
ok( $cres, "Client received response from server");
is_deeply({ foo => 'bar' }, $cres, 'echo response ok');
diag "Client->Server OK";

# Let server send echo to client and wait for response
#use Data::Dumper;
#warn Data::Dumper->Dump($server->_peers, ["*** _peers"]);
my $connected = $server->_peers->[-1];
my $sres = $connected->call( echo => { foo => 'bar' } )->recv;
ok( $sres, "Server received response from client");
is_deeply({ foo => 'bar' }, $sres, 'echo response ok');
diag "Server->Client OK";
