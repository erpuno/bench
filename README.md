# BENCH: Performance tool for distributed systems

Feartures
---------

* Multi-server, Multi-IP-address, Multi-Protocol support
* Scripting Language for tests scripts
* Telemetry Dashboarding
* Tiny Size

Defaults and Limits
-------------------

* IANA/BSD: 49152 — 65535 = C16383
* Linux: 32768 — 61000 = C28232
* Maximum per IP address: 1024 — 65535 = C64511

Setup
-----

* https://gist.github.com/tombigel/d503800a282fcadbee14b537735d202c
* https://news.ycombinator.com/item?id=2288301
* `sudo sysctl -w net.inet.ip.portrange.first=1024`
* `sudo sysctl -w net.inet.ip.portrange.hifirst=1024`

Run Investigated Application
----------------------------

```sh
$ git clone https://github.com/o7/chat && cd chat
$ mix deps.get
$ iex -S mix
```

Run Bench
---------

```sh
$ git clone https://github.com/o7/bench && cd bench
$ mix deps.get
$ iex -S mix
```

Check connections and liveness
------------------------------

```sh
$ lsof -Pn -i4 | grep "8042 " | grep ESTABLISHED | wc -l
50000
```

```elixir
iex(2)> send :n2o_pi.pid(:caching,"Bench 50000"), {:send_msg, "AUTH maxim"}
"Send \"Bench 50000\""
{:send_msg, "AUTH maxim"}
iex(3)> "Income {:text, \"USER maxim\"}"
```

Credits
-------

* Georgi Spasov
* Maxim Sokhatsky
