#!/bin/bash

# define
DATE=`date '+%Y%m%d%H%M%S'`
DIR="log"

# start
start() {
  CMDLIST=$1

  if [ ! -d ${DIR} ]; then
    echo "INFO : Create directory - ${DIR}"
    mkdir -p ${DIR}
  fi
  
  BUFIFS=${IFS}
  grep -v '^#' ${CMDLIST} | while IFS=, read CMD LOG PIDFILE;
  do
    IFS=
    eval "${CMD} >> ${DIR}/${LOG} 2>&1 &"
    echo $! > ${PIDFILE}
    IFS=${BUFIFS}
  done
}


# stop
stop() {
  CMDLIST=$1

  BUFIFS=${IFS}
  grep -v '^#' ${CMDLIST} | while IFS=, read CMD LOG PIDFILE;
  do  
    IFS=
    if [ ! -f ${PIDFILE} ]; then
      echo "ERROR : Can NOT found pid file - ${PIDFILE}"
      IFS=${BUFIFS}
      continue
    fi
    PID=`cat ${PIDFILE}`
    if kill -0 ${PID}; then
      kill ${PID}
      rm -f ./${PIDFILE}
      if [ -f ${PIDFILE} ]; then
        echo "WARNNING : Can NOT delete pid file - ${PIDFILE}"
      fi
    else
      echo "WARNNING : Can NOT found pid - ${PID} in ${PIDFILE}"
    fi
    IFS=${BUFIFS}
  done
}


check_must() {
  CMDLIST=$1

  if [ ! -f ${CMDLIST} ]; then
    echo "ERROR : Can NOT found cmd list - ${CMDLIST}"
    echo "Usage: $0 {start|stop} command-list"
    exit 1;
  fi

}

# see how we were called.
case "$1" in
  start)
    check_must $2
    start $2
    ;;
  stop)
    check_must $2
    stop $2
    ;;
  *)
    echo "Usage: $0 {start|stop} command-list"
    exit 1
esac
