use inc::Module::Install;
name 'AnyEvent-JSONRPC';
all_from 'lib/AnyEvent/JSONRPC.pm';

requires 'Any::Moose';
requires 'AnyEvent' => '5.12';
requires 'JSON';
recommends 'JSON::XS';

test_requires 'Test::More';
test_requires 'Test::TCP';

author_tests('xt');
use_test_base;

auto_include;
auto_set_repository;

WriteAll;
