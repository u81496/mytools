# myTools

## dateseq

### How to Use
```
$ ./dateseq [-s separator] [startDate [increment]] endDate
```

#### example
```
$ ./dateseq 20190215
(TODAY)
(TOMORROW)
...
20190214
20190215

$ ./dateseq 20190101 20190215
20190101
20190102
...
20190214
20190215

$ ./dateseq 20190101 2 20190215
20190101
20190103
...
20190212
20190214

$ ./dateseq -s'-' 20190101 20190215
2019-01-01
2019-01-02
...
2019-02-14
2019-02-15
```

## cron-checker

### How to Use
```
$ ./cron-checker.rb min hour day month dow [limit=5]
```

#### example
```
$ ./cron-checker.rb '0' '0' '29' '2' '*' 10
2020/02/29(Sat) 00:00:00
2024/02/29(Thu) 00:00:00
2028/02/29(Tue) 00:00:00
2032/02/29(Sun) 00:00:00
2036/02/29(Fri) 00:00:00
2040/02/29(Wed) 00:00:00
2044/02/29(Mon) 00:00:00
2048/02/29(Sat) 00:00:00
2052/02/29(Thu) 00:00:00
2056/02/29(Tue) 00:00:00
```
