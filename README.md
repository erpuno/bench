# BENCH: Performance tool for distributed systems

MacBook Air Setup
-----------------

* https://gist.github.com/tombigel/d503800a282fcadbee14b537735d202c
* `sudo sysctl -w net.inet.ip.portrange.first=1024`

Stand
-----

```sh
$ git clone https://github.com/o7/chat && cd chat
$ mix deps.get
$ iex -S mix
```

Bench
-----

```sh
$ git clone https://github.com/o7/bench && cd bench
$ mix deps.get
$ iex -S mix
```

Check connections
-----------------

```sh
$ lsof -Pn -i4 | grep "8042 " | grep ESTABLISHED | wc -l
50000
```


Credits
-------

* Georgi Spasov
* Maxim Sokhatsky
