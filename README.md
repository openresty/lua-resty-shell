Name
====

lua-resty-shell - Lua module for nonblocking system shell command executions

Table of Contents
=================

* [Name](#name)
* [Synopsis](#synopsis)
* [Functions](#functions)
    * [run](#run)
* [Dependencies](#dependencies)
* [Author](#author)
* [Copyright & Licenses](#copyright--licenses)

Synopsis
========

```lua
local shell = require "resty.shell"

local stdin = "hello"
local timeout = 1000  -- ms
local max_size = 4096  -- byte

local ok, stdout, stderr, reason, status =
    shell.run([[perl -e 'warn "he\n"; print <>']], stdin, timeout, max_size)
if not ok then
    -- ...
end
```

Functions
=========

run
---

**syntax:** `ok, stdout, stderr, reason, status = shell.run(cmd, stdin?, timeout?, max_size?)`

**context:** `all phases supporting yielding`

Runs a shell command, `cmd`, with an optional stdin.

The `cmd` argument can either be a single string value (e.g. `"echo 'hello,
world'"`) or an array-like Lua table (e.g. `{"echo", "hello, world"}`). The
former is equivalent to `{"/bin/sh", "-c", "echo 'hello, world'"}`, but simpler
and slightly faster.

When the `stdin` argument is `nil` or `""`, the stdin device will immediately
be closed.

The `timeout` argument specifies the timeout threshold (in ms) for
stderr/stdout reading timeout, stdin writing timeout, and process waiting
timeout.

The `max_size` argument specifies the maximum size allowed for each output
data stream of stdout and stderr. When exceeding the limit, the `run()`
function will immediately stop reading any more data from the stream and return
an error string in the `reason` return value: `"failed to read stdout: too much
data"`.

Upon terminating successfully (with a zero exit status), `ok` will be `true`,
`reason` will be `"exit"`, and `status` will hold the sub-process exit status.

Upon terminating abnormally (non-zero exit status), `ok` will be `false`,
`reason` will be `"exit"`, and `status` will hold the sub-process exit status.

Upon exceeding a timeout threshold or any other unexpected error, `ok` will be
`nil`, and `reason` will be a string describing the error.

When a timeout threshold is exceeded, the sub-process will be terminated as
such:

1. first, by receiving a `SIGTERM` signal from this library,
2. then, after 1ms, by receiving a `SIGKILL` signal from this library.

Note that child processes of the sub-process (if any) will not be terminated.
You may need to terminate these processes yourself.

When the sub-process is terminated by a UNIX signal, the `reason` return value
will be `"signal"` and the `status` return value will hold the signal number.

[Back to TOC](#table-of-contents)

Dependencies
============

This library depends on

* the [lua-resty-signal](https://github.com/openresty/lua-resty-signal) library.
* the [ngx.pipe](https://github.com/openresty/lua-resty-core/blob/master/lib/ngx/pipe.md#readme)
API of OpenResty.
* the [lua-tablepool](https://github.com/openresty/lua-tablepool) library.

[Back to TOC](#table-of-contents)

Author
======

Yichun Zhang (agentzh) <yichun@openresty.com>

[Back to TOC](#table-of-contents)

Copyright & Licenses
====================

This module is licensed under the BSD license.

Copyright (C) 2018-2019, [OpenResty Inc.](https://openresty.com)

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

* Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

[Back to TOC](#table-of-contents)

