use strict;
use Test::More tests => 4;

BEGIN {
    use_ok 'AnyEvent::JSONRPC';
    use_ok 'AnyEvent::JSONRPC::Client';
    use_ok 'AnyEvent::JSONRPC::Server';
    use_ok 'AnyEvent::JSONRPC::CondVar';
}
