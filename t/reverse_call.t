use Test::Base;

#plan tests => 3;
plan tests => 1;

use Test::TCP;
use AnyEvent::JSONRPC::TCP::Client;
use AnyEvent::JSONRPC::TCP::Server;

my $port = empty_port;

# client;
my $client = AnyEvent::JSONRPC::TCP::Client->new(
    host => '127.0.0.1',
    port => $port,
    version => '1.0',
);

## server
my $server = AnyEvent::JSONRPC::TCP::Server->new( port => $port );
$server->reg_cb(
    echo => sub {
        my ($result_cv, @params) = @_;
        ok("Echo called ok");
        is_deeply({ foo => 'bar' }, $params[0], 'echo param ok');
        $result_cv->result(@params);
    }
);


# TODO
#my $res = $server->call( echo => { foo => 'bar' } )->recv;
#is_deeply({ foo => 'bar' }, $res, 'echo response ok');

ok(1, 'no tests performed');
