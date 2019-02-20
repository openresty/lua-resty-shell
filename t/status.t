# vi:ft=

use lib '.';
use t::TestShell;

plan tests => 3 * blocks();

no_long_string();
#no_diff();

run_tests();

__DATA__

=== TEST 1: exit 1
--- config
    location = /t {
        content_by_lua_block {
            local say = ngx.say
            local shell = require "resty.shell"

            do
                local ok, stdout, stderr, reason, status =
                    shell.run([[perl -e 'warn "he\n"; print "yes"; exit 1']], nil, 2000)
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
ok: false
stdout: yes
stderr: he

reason: exit
status: 1



=== TEST 2: exit 255
--- config
    location = /t {
        content_by_lua_block {
            local say = ngx.say
            local shell = require "resty.shell"

            do
                local ok, stdout, stderr, reason, status =
                    shell.run([[perl -e 'print "yes"; die;']], nil, 2000)
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
ok: false
stdout: yes
stderr: Died at -e line 1.

reason: exit
status: 255
