# fluent-plugin-stdout_ex

## About

Fluentd out\_stdout extension

## What is this for?

Think of the output of `out_stdout`:

```
2010-05-04 12:02:01 +0900 test: {"test":"test"}
```

The time field expresses the time parameter of messages, i.e., the time when the message is created or, the time written in application logs.
This is not the current time of *logging`. 

The `out_stdout_ex` output as:

```
2010-05-04 12:02:01 +0900[info]: 2010-05-04 12:02:01 +0900 test: {"test":"test"}
```

where the first time expresses the current time of *logging*.

This is very useful because we can see the latency between receiving (logging) and sending (creating) of messages.


## Configuration

```apache
<match **>
  type stdout_ex
</match>
```

## Parameters

Basically same with out\_stdout plugin. See http://docs.fluentd.org/articles/out_stdout

* format ltsv

   The output becomes LTSV format as followings:
    
   current_time:2010-05-04 12:02:01 +0900    time:2010-05-04 12:02:01 +0900    tag:test    record:{"test":"test"}

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](../../pull/new/master)

## ChangeLog

See [CHANGELOG.md](CHANGELOG.md) for details.

## stdoutright

* stdoutright (c) 2014- Naotoshi Seo
* See [LICENSE](LICENSE) for details.
