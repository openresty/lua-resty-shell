# vi:ft=

use lib '.';
use t::TestShell;

plan tests => 3 * blocks();

no_long_string();
#no_diff();

run_tests();

__DATA__

=== TEST 1: too much stderr data (1 byte more)
--- config
    location = /t {
        content_by_lua_block {
            local say = ngx.say
            local shell = require "resty.shell"

            do
                local ok, stdout, stderr, reason, status =
                    shell.run([[perl -e 'warn "hel\n"; print "yes"']], nil, 3000, 3)
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
ok: nil
stdout: yes
stderr: hel

reason: failed to read stderr: too much data
status: nil



=== TEST 2: too much stderr data (several bytes more)
--- config
    location = /t {
        content_by_lua_block {
            local say = ngx.say
            local shell = require "resty.shell"

            do
                local ok, stdout, stderr, reason, status =
                    shell.run([[perl -e 'warn "hello world\n"; print "yes"']],
                              nil, 3000, 3)
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
ok: nil
stdout: yes
stderr: hell
reason: failed to read stderr: too much data
status: nil



=== TEST 3: stderr timeout
--- config
    location = /t {
        content_by_lua_block {
            local say = ngx.say
            local shell = require "resty.shell"

            do
                local ok, stdout, stderr, reason, status =
                    shell.run([[perl -e 'print "yes"; sleep 10; warn "he\n";']],
                              nil, 1, 3)
                say("ok: ", ok)
                say("stdout: '", stdout, "'")
                say("stderr: '", stderr, "'")
                say("reason: ", reason)
                say("status: ", status)
            end
            collectgarbage()
        }
    }
--- response_body
ok: nil
stdout: ''
stderr: ''
reason: failed to wait for process: timeout
status: nil
