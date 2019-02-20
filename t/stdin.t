# vi:ft=

use lib '.';
use t::TestShell;

plan tests => 3 * blocks();

no_long_string();
#no_diff();

run_tests();

__DATA__

=== TEST 1: good case
--- config
    location = /t {
        content_by_lua_block {
            local say = ngx.say
            local shell = require "resty.shell"

            do
                local ok, stdout, stderr, reason, status =
                    shell.run([[perl -e 'my $ln = <>; print $ln']], "hello", 3000)
                say("ok: ", ok)
                say("stdout: ", stdout)
                say("stderr: ", stderr)
                say("reason: ", reason)
                say("status: ", status)
            end
            collectgarbage()
        }
    }
--- response_body
ok: true
stdout: hello
stderr: 
reason: exit
status: 0
