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

**context:** `any phases supporting yielding`

Runs a shell command, `cmd`, with an optional stdin.

The `cmd` argument can either be a single string value, like `"echo 'hello, world'"`,
or an array-like Lua table, like `{"echo", "hello, world"}`. The former form is
equivalent to `{"/bin/sh", "-c", "echo 'hello, world'"}`, but just a little bit
faster.

When stdin is nil or an empty string, the stdin device will get closed immediately.

The `timeout` parameter speifies the timeout threshold in milliseconds for stderr/stdout reading timeout,
the stdin writing timeout, and the process waiting timeout, respectively.

The `max_size` parameter specifies the maximum size allowed for each output data stream of
stdout and stderr. When exceeding the limit, the `run()` function will immediately
stop reading any more data from the stream and returns an error string in the `reason` return
value like `"failed to read stdout: too much data"`.

When the sub-process terminates by itself, the `reason` return value will be `"exit"`
and the `status` return value will be the exit code returned by the sub-process.

When the sub-process is terminated by some UNIX signals, the `reason` return value
will be `"signal"` and the `status` return value will hold the signal number.

The first return value, `ok`, will only take a true value (`true`) when the process
is exited successfully (with the zero status code).

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

