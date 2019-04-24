# vi:ft=

use lib '.';
use t::TestShell;

plan tests => 3 * blocks();

no_long_string();
#no_diff();

run_tests();

__DATA__

=== TEST 1: good case (single shell cmd string)
--- config
    location = /t {
        content_by_lua_block {
            local say = ngx.say
            local shell = require "resty.shell"

            do
                local ok, stdout, stderr, reason, status =
                    shell.run([[perl -e 'warn "he\n"; print "yes"']], nil, 3000, 3)
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
stdout: yes
stderr: he

reason: exit
status: 0



=== TEST 2: good case (shell cmd arg vector)
--- config
    location = /t {
        content_by_lua_block {
            local say = ngx.say
            local shell = require "resty.shell"

            do
                local ok, stdout, stderr, reason, status =
                    shell.run({'perl', '-e', [[warn "he\n"; print "yes"]]}, nil, 3000)
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
stdout: yes
stderr: he

reason: exit
status: 0



=== TEST 3: too much stdout data (1 byte more)
--- config
    location = /t {
        content_by_lua_block {
            local say = ngx.say
            local shell = require "resty.shell"

            do
                local ok, stdout, stderr, reason, status =
                    shell.run([[perl -e 'warn "he\n"; print "yes!"']], nil, 3000, 3)
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
stdout: yes!
stderr: he

reason: failed to read stdout: too much data
status: nil



=== TEST 4: too much stdout data (several bytes more)
--- config
    location = /t {
        content_by_lua_block {
            local say = ngx.say
            local shell = require "resty.shell"

            do
                local ok, stdout, stderr, reason, status =
                    shell.run([[perl -e 'warn "he\n"; print "yes!!!yes~"']],
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
stdout: yes!
stderr: he

reason: failed to read stdout: too much data
status: nil



=== TEST 5: stdout timeout
--- config
    location = /t {
        content_by_lua_block {
            local say = ngx.say
            local shell = require "resty.shell"

            do
                local ok, stdout, stderr, reason, status =
                    shell.run([[perl -e 'warn "he\n"; sleep 10; print "yes"']],
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
--- response_body_like chomp
\Aok: nil
stdout: ''
stderr: '(?:|he
)'
reason: failed to wait for process: timeout
status: nil
\z



=== TEST 6: clean up the sub-process when failed to wait
--- config
    location = /t {
        content_by_lua_block {
            local say = ngx.say
            local shell = require "resty.shell"
            local ok, stdout, stderr, reason, status =
                shell.run([[echo aaaaa && sleep 10]], nil, 100, 3)
            say("ok: ", ok)
            say("stdout: '", stdout, "'")
            say("stderr: '", stderr, "'")
            say("reason: ", reason)
            say("status: ", status)
        }
    }
--- response_body
ok: nil
stdout: 'aaaa'
stderr: ''
reason: failed to wait for process: timeout
status: nil
--- error_log
lua pipe SIGCHLD fd read pid:
--- wait: 0.2
