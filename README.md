# BENCH: Performance tool for distributed systems

Stand
-----

```
$ git clone https://github.com/o7/chat && cd chat
$ mix deps.get
$ iex -S mix
```

Bench
-----

```
$ git clone https://github.com/o7/bench && cd bench
$ mix deps.get
$ iex -S mix
```

Check connections
-----------------

```
$ lsof -Pn -i4 | grep "8042 " | wc -l
```

Credits
-------

* Georgi Spasov
* Maxim Sokhatsky

