# bgcmd
background command

## Description
this is tool that execute command and logging in background process.

## Install
clone from github

```
# git clone https://github.com/Y05H1/bgcmd.git
```

## Usage

edit cmdlist
```
# cat cmdlist
#command,console log,pid file
tail -f /var/log/messages,${DATE}_messages.log,messages.pid
tail -f /var/log/httpd/access_log,${DATE}_http_access.log,http_access.pid
tcpdump -s 1500 -w ${DIR}/${DATE}_tcpdump.pcap,${DATE}_tcpdump.log,tcpdump.pid
```

- ${DIR} is bgcmd default log directory(./log).
- ${DATE} is bgcmd start date(YYYYMMDDHHMMSS).


start bgcmd
```
# ./bgcmd.sh start cmdlist
```

after some tests, stop bgcmd
```
# ./bgcmd.sh stop cmdlist
```

check log file
```
# ls log/
```

