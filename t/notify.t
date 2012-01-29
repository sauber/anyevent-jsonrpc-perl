use Test::Base;

plan tests => 3;

use Test::TCP;
use AnyEvent::JSONRPC::TCP::Client;
use AnyEvent::JSONRPC::TCP::Server;

my $cv = AnyEvent->condvar;
my $port = empty_port;

## server
my $server = AnyEvent::JSONRPC::TCP::Server->new( port => $port );
$server->reg_cb(
    echo => sub {
        my ($result_cv, @params) = @_;
        ok(1, "Echo called ok");
        is_deeply({ foo => 'bar' }, $params[0], 'echo param ok');
        $result_cv->result(@params);
        $cv->send;
    }
);

# client;
my $client = AnyEvent::JSONRPC::TCP::Client->new(
    host => '127.0.0.1',
    port => $port,
    version => '1.0',
);

ok( $client->notify( echo => { foo => 'bar' } ), 'notify call ok');

# Wait for server to get request
$cv->recv;
